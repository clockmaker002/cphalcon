
/*
 +------------------------------------------------------------------------+
 | Phalcon Framework                                                      |
 +------------------------------------------------------------------------+
 | Copyright (c) 2011-2013 Phalcon Team (http://www.phalconphp.com)       |
 +------------------------------------------------------------------------+
 | This source file is subject to the New BSD License that is bundled     |
 | with this package in the file docs/LICENSE.txt.                        |
 |                                                                        |
 | If you did not receive a copy of the license and are unable to         |
 | obtain it through the world-wide-web, please send an email             |
 | to license@phalconphp.com so we can send you a copy immediately.       |
 +------------------------------------------------------------------------+
 | Authors: Andres Gutierrez <andres@phalconphp.com>                      |
 |          Eduar Carvajal <eduar@phalconphp.com>                         |
 +------------------------------------------------------------------------+
 */

namespace Phalcon\Mvc\Collection;

/**
 * Phalcon\Mvc\Collection\Manager
 *
 * This components controls the initialization of models, keeping record of relations
 * between the different models of the application.
 *
 * A CollectionManager is injected to a model via a Dependency Injector Container such as Phalcon\Di.
 *
 * <code>
 * $di = new Phalcon\Di();
 *
 * $di->set('collectionManager', function(){
 *      return new Phalcon\Mvc\Collection\Manager();
 * });
 *
 * $robot = new Robots($di);
 * </code>
 */
class Manager implements Phalcon\Di\InjectionAwareInterface, Phalcon\Events\EventsAwareInterface
{

	protected _dependencyInjector;

	protected _initialized;

	protected _lastInitialized;

	protected _eventsManager;

	protected _customEventsManager;

	protected _connectionServices;

	protected _implicitObjectsIds;

	/**
	* Sets the DependencyInjector container
	*
	* @param Phalcon\DiInterface $dependencyInjector
	*/
	public function setDI(<Phalcon\DiInterface> dependencyInjector) -> void
	{
		let this->_dependencyInjector = dependencyInjector;
	}

	/**
	* Returns the DependencyInjector container
	*
	* @return Phalcon\DiInterface
	*/
	public function getDI() -> <Phalcon\DiInterface>
	{
		return this->_dependencyInjector;
	}

	/**
	* Sets the event manager
	*
	* @param Phalcon\Events\ManagerInterface $eventsManager
	*/
	public function setEventsManager(<Phalcon\Events\ManagerInterface> eventsManager) -> void
	{
		let this->_eventsManager = eventsManager;
	}

	/**
	* Returns the internal event manager
	*
	* @return Phalcon\Events\ManagerInterface
	*/
	public function getEventsManager() -> <Phalcon\Events\ManagerInterface>
	{
		return this->_eventsManager;
	}

	/**
	* Sets a custom events manager for a specific model
	*
	* @param Phalcon\Mvc\CollectionInterface $model
	* @param Phalcon\Events\ManagerInterface $eventsManager
	*/
	public function setCustomEventsManager(<Phalcon\Mvc\CollectionInterface> model, <Phalcon\Events\ManagerInterface> eventsManager) -> void
	{
		var className;

		let className = get_class(model);
		let this->_customEventsManager[className] = eventsManager;
	}

	/**
	* Returns a custom events manager related to a model
	*
	* @param Phalcon\Mvc\CollectionInterface $model
	* @return Phalcon\Events\ManagerInterface
	*/
	public function getCustomEventsManager(<Phalcon\Mvc\CollectionInterface> model) //-> <Phalcon\Events\ManagerInterface>
	{
		var customEventsManager, className;

		let customEventsManager = this->_customEventsManager;
		if typeof customEventsManager == "array" {
			let className = get_calls(model);
			if isset customEventsManager[className] {
				return customEventsManager[className];
			}
		}
	}

	/**
	* Initializes a model in the models manager
	*
	* @param Phalcon\Mvc\CollectionInterface $model
	*/
	public function initialize(<Phalcon\Mvc\CollectionInterface> model) -> void
	{
		var className, initialized, eventsManager;

		let className = get_class(model);
		let initialized = this->_initialized;

		/**
		* Models are just initialized once per request
		*/
		if !isset initialized[className] {

			/**
			* Call the 'initialize' method if it's implemented
			*/
			if method_exists(model, "initialize") == true {
				model->{"initialize"}();
			}

			/**
			* If an EventsManager is available we pass to it every initialized model
			*/
			let eventsManager = this->_eventsManager;
			if typeof eventsManager == "object" {
				eventsManager->fire("collectionManager:afterInitialize");
			}

			let this->_initialized[className] = model;
			let this->_lastInitialized = model;
		}
	}

	/**
	* Check whether a model is already initialized
	*
	* @param string $modelName
	* @return bool
	*/
	public function isInitialized(modelName) -> boolean
	{
		var initialized, lowerCased;

		let initialized = this->_initialized;
		let lowerCased = strtolower(modelName);

		if isset initialized[lowerCased] {
			return true;
		}
		return false;
	}

	/**
	* Get the latest initialized model
	*
	* @return Phalcon\Mvc\CollectionInterface
	*/
	public function getLastInitialized() -> <Phalcon\Mvc\CollectionInterface>
	{
		return this->_lastInitialized;
	}

	/**
	* Sets a connection service for a specific model
	*
	* @param Phalcon\Mvc\CollectionInterface $model
	* @param string $connectionService
	*/
	public function setConnectionService(<Phalcon\Mvc\CollectionInterface> model, connectionService) -> void
	{
		var entityName;

		if typeof model != "object" {
			throw new Phalcon\Mvc\Collection\Exception("A valid collection instance is required");
		}

		let entityName = get_class(model);
		let this->_connectionServices[entityName] = connectionService;

	}

	/**
	* Sets if a model must use implicit objects ids
	*
	* @param Phalcon\Mvc\CollectionInterface $model
	* @param boolean $useImplicitObjectIds
	*/
	public function useImplicitObjectIds(<Phalcon\Mvc\CollectionInterface> model, useImplicitObjectIds) -> void
	{
		var entityName;

		if typeof model != "object" {
			throw new Phalcon\Mvc\Collection\Exception("A valid collection instance is required");
		}

		let entityName = get_class(model);
		let this->_implicitObjectsIds[entityName] = useImplicitObjectIds;
	}

	/**
	* Checks if a model is using implicit object ids
	*
	* @param Phalcon\Mvc\CollectionInterface $model
	* @return boolean
	*/
	public function isUsingImplicitObjectIds(<isUsingImplicitObjectIds> model) -> boolean
	{

	}

}
