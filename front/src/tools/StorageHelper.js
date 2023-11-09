/**
 * An helper class for reading/storing data with the Storage
 */
export default class StorageHelper {
  constructor() {
    /** @type {Storage} */
    this.storage = localStorage;
  }

  /**
   * Get the data from storage and parse into a JavaScript Object
   * @param {string} key - The name of the resource
   * */
  get(key) {
    return JSON.parse(this.storage.getItem(key));
  }

  /**
   * Stores the data in storage
   * @param {string} key - The name of the resource
   * @param {object} data - A JavaScript Object to store
   * */
  set(key, data) {
    this.storage.setItem(key, JSON.stringify(data));
  }

  /**
   * Removes the data in storage
   * @param {string} key - The name of the resource
   * */
  remove(key) {
    this.storage.removeItem(key);
  }

  /**
   * Makes sure the storage has minimal data for desired key 
   * @param {string} key - The name of the resource
   * @param {object} data - A JavaScript Object to store
   * */
  ensure(key, data) {
    if (!this.get(key)) {
      this.set(key, JSON.stringify(data));
    }
  }
}
