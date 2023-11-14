import StorageHelper from "./StorageHelper";
import { Network } from '@capacitor/network';
import { Dialog } from '@capacitor/dialog';
import store from "../store";

const storedReqs = 'requests';

class NetworkManager {
    constructor() {
        this.api = import.meta.env.VITE_API_HOST + ':' + import.meta.env.VITE_API_PORT
        this.storage = new StorageHelper()
        this.storage.ensure(storedReqs, [])
        this.status = {
            connected: false, // Initialisez le statut de connexion à false
            connectionType: 'unknown'
        }
        this.networkReady = Network.getStatus() // Stockez la promesse dans une variable
            .then(status => this.updateStatus(status))
            .then(Network.addListener('networkStatusChange', status => this.updateStatus(status)))
    }

    async updateStatus(status) {
        /** contient "connected" (boolean) et "connectionType" ('wifi' | 'cellular' | 'none' | 'unknown') */
        this.status = status;

        console.log(status);

        // await Dialog.alert({
        //     title: 'Changement de connection',
        //     message: JSON.stringify(status),
        // })

        // await Dialog.confirm({
        //     title: 'Confirm',
        //     message: `Ok t'as lu ?`,
        // });

        if (this.status.connected) {
            this.processPendingRequests()
        }
    }

    processPendingRequests() {
        /** @type {array} */
        const requests = this.storage.get(storedReqs) || []
        this.storage.set(storedReqs, [])
        requests.forEach(req => {
            this.fetch(req.method, req.uri, req.body)
        })
    }

    fetch(method, uri, body) {
        // Attendez que la promesse networkReady soit résolue avant de faire des appels API
        return this.networkReady.then(() => {
            // store request if offline
            if (!this.status.connected) {
                /** @type {array} */
                const requests = this.storage.get(storedReqs) || []
                requests.push({ method, uri, body });
                this.storage.set(storedReqs, requests.filter(req => req.method !== method && req.uri !== uri));
                return
            }
            // exec request if online
            return fetch(this.api + uri, {
                method: method,
                //credentials: 'include',
                headers: {
                    'Accept': 'application/json',
                    'Content-Type': 'application/json',
                    'Authorization': 'Bearer ' + localStorage.getItem('token') || '',
                    'x-csrf-token': store.getters['auth/csrfToken']
                },
                body: body instanceof Object ? JSON.stringify(body) : body
            })
        });
    }

    get(uri) {
        return this.fetch('GET', uri)
    }

    post(uri, body) {
        return this.fetch('POST', uri, body)
    }

    put(uri, body) {
        return this.fetch('PUT', uri, body)
    }

    delete(uri) {
        return this.fetch('DELETE', uri)
    }
}

const network = new NetworkManager();

export default network;
