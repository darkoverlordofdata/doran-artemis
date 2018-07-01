/**
 * The primary instance for the framework. It contains all the managers.
 * 
 * You must use this to create, delete and retrieve entities.
 * 
 * It is also important to set the delta each game loop iteration, and initialize before game loop.
 * 
 * @author Arni Arent
 * 
 */
using Gee;
using Artemis.Utils;
using Artemis.Annotations;

namespace Artemis {
    

    public delegate void Performer(EntityObserver observer, Entity e);

    public class World {
        private EntityManager em;
        private ComponentManager cm;
    
        public float delta;
        private Bag<Entity> _added;
        private Bag<Entity> _changed;
        private Bag<Entity> _deleted;
        private Bag<Entity> _enable;
        private Bag<Entity> _disable;
    
        private HashMap<Type, Manager> managers;
        private Bag<Manager> managersBag;
        
        private HashMap<Type, EntitySystem> systems;
        private Bag<EntitySystem> systemsBag;

        private HashMap<string, IEntityTemplate> entityTemplates;

        public World() {
            managers = new HashMap<Type, Manager>();
            managersBag = new Bag<Manager>();
            
            systems = new HashMap<Type, EntitySystem>();
            systemsBag = new Bag<EntitySystem>();
    
            _added = new Bag<Entity>();
            _changed = new Bag<Entity>();
            _deleted = new Bag<Entity>();
            _enable = new Bag<Entity>();
            _disable = new Bag<Entity>();
    
            cm = new ComponentManager();
            setManager(cm);
            
            em = new EntityManager();
            setManager(em);
        }
    
        
        /**
         * Makes sure all managers systems are initialized in the order they were added.
        */
        public void initialize() {
            for (var i = 0; i < managersBag.size(); i++) {
                managersBag[i].initialize();
            }
            
            /** 
             * annotaions.EntityTemplate 
             * 
             * Collect the entity templates
             */
            entityTemplates = new HashMap<string, IEntityTemplate>();
            foreach (var entityName in EntityTemplate.entityTemplates.keys) {
                var Template = (Type)EntityTemplate.entityTemplates[entityName];
                setEntityTemplate(entityName, (IEntityTemplate)Object.new(Template));
            }
            
            /** 
             * annotations.Mapper 
             *
             * Collect the component mappers
             */
            for (var i = 0; i < systemsBag.size(); i++) {
                /** Inject the component mappers into each system */
                ComponentMapperInitHelper.config(systemsBag[i], this);
                systemsBag[i].initialize();
            }
        }
        
        
        /**
         * Returns a manager that takes care of all the entities in the world.
         * entities of this world.
         * 
         * @return entity manager.
         */
        public EntityManager getEntityManager() {
            return em;
        }
        
        /**
         * Returns a manager that takes care of all the components in the world.
        * 
        * @return component manager.
        */
        public ComponentManager getComponentManager() {
            return cm;
        }
        
        
        
    
        /**
         * Add a manager into this world. It can be retrieved later.
        * World will notify this manager of changes to entity.
        * 
        * @param manager to be added
        */
        public Manager setManager(Manager manager) {
            managers[manager.get_type()] = manager;
            managersBag.add(manager);
            manager.setWorld(this);
            return manager;
        }
    
        /**
         * Returns a manager of the specified type.
        * 
        * @param <T>
        * @param managerType
        *            class type of the manager
        * @return the manager
        */
        public T getManager<T>(Type managerType) {
            return managers[managerType];
        }
        
        /**
         * Deletes the manager from this world.
        * @param manager to delete.
        */
        public void deleteManager(Manager manager) {
            managers.remove(manager.get_type());
            managersBag.remove(manager);
        }
        
        
        /**
         * Time since last game loop.
        * 
        * @return delta time since last game loop.
        */
        public float getDelta() {
            return delta;
        }
    
        /**
         * You must specify the delta for the game here.
        * 
        * @param delta time since last game loop.
        */
        public void setDelta(float delta) {
            delta = delta;
        }
    
    
        /**
         * Adds a entity to this world.
        * 
        * @param e entity
        */
        public void addEntity(Entity e) {
            _added.add(e);
        }
        
        /**
         * Ensure all systems are notified of changes to this entity.
        * If you're adding a component to an entity after it's been
        * added to the world, then you need to invoke this method.
        * 
        * @param e entity
        */
        public void changedEntity(Entity e) {
            _changed.add(e);
        }
        
        /**
         * Delete the entity from the world.
        * 
        * @param e entity
        */
        public void deleteEntity(Entity e) {
            if (!_deleted.contains(e)) {
                _deleted.add(e);
            }
        }
    
        /**
         * (Re)enable the entity in the world, after it having being disabled.
        * Won't do anything unless it was already disabled.
        */
        public void enable(Entity e) {
            _enable.add(e);
        }
    
        /**
         * Disable the entity from being processed. Won't delete it, it will
        * continue to exist but won't get processed.
        */
        public void disable(Entity e) {
            _disable.add(e);
        }
    
    
        /**
         * Create and return a new or reused entity instance.
        * Will NOT add the entity to the world, use World.addEntity(Entity) for that.
        *
        * @param name optional name for debugging
        * @return entity
        */
        public Entity createEntity(string name="") {
            return em.createEntityInstance(name);
        }
    
        /**
         * Get a entity having the specified id.
        * 
        * @param entityId
        * @return entity
        */
        public Entity getEntity(int entityId) {
            return em.getEntity(entityId);
        }
    
    
        /**
         * Gives you all the systems in this world for possible iteration.
        * 
        * @return all entity systems in world.
        */
        public ImmutableBag<EntitySystem> getSystems() {
            return systemsBag;
        }
    
        /**
         * Adds a system to this world that will be processed by World.process()
        * 
        * @param system the system to add.
        * @return the added system.
        */
        // public setSystem(system:T):<T extends EntitySystem> T  {
        // 	return setSystem(system, false);
        // }
    
        /**
         * Will add a system to this world.
        *  
        * @param system the system to add.
        * @param passive wether or not this system will be processed by World.process()
        * @return the added system.
        */
        //	public <T extends EntitySystem> T setSystem(T system, boolean passive) {

        public T setSystem<T>(EntitySystem system, bool passive=false) {
            system.setWorld(this);
            system.setPassive(passive);
            
            systems[system.get_type()] = system;
            systemsBag.add(system);
            
            return system;
        }
        
        /**
         * Removed the specified system from the world.
        * @param system to be deleted from world.
        */
        public void deleteSystem(EntitySystem system) {
            systems.remove(system.get_type());
            systemsBag.remove(system);
        }
        
        private void notifySystems(Performer perform, Entity e) {
            for (var i = 0, s=systemsBag.size(); s > i; i++) {
                perform(systemsBag[i], e);
            }
        }
    
        private void notifyManagers(Performer perform, Entity e) {
            for (var a = 0, s = managersBag.size(); s > a; a++) {
                perform(managersBag[a], e);
            }
        }
        
        /**
         * Retrieve a system for specified system type.
        * 
        * @param type type of system.
        * @return instance of the system in this world.
        */
        public EntitySystem getSystem(Type type) {
            return systems.get(type);
        }

        /**
         * Performs an action on each entity.
        * @param entities
        * @param performer
        */
        private void check(Bag<Entity> entities, Performer perform) {
            if (!entities.isEmpty()) {
                for (var i = 0, s = entities.size(); s > i; i++) {
                    var e = entities[i];
                    notifyManagers(perform, e);
                    notifySystems(perform, e);
                }
                entities.clear();
            }
        }
    
        
        /**
         * Process all non-passive systems.
        */
        public void process() {

            check(_added, (observer, e) => observer.added(e));
            check(_changed, (observer, e) => observer.changed(e));
            check(_disable, (observer, e) => observer.disabled(e));
            check(_enable, (observer, e) => observer.enabled(e));
            check(_deleted, (observer, e) => observer.deleted(e));
            
            cm.clean();
            
            for (var i = 0; systemsBag.size() > i; i++) {
                var system = systemsBag[i];
                if(!system.isPassive()) {
                    system.process();
                }
            }
        }
        
    
        /**
         * Retrieves a ComponentMapper instance for fast retrieval of components from entities.
        * 
        * @param type of component to get mapper for.
        * @return mapper for specified component type.
        */
        public ComponentMapper<T> getMapper<T>(Type type) {
            return ComponentMapper.getFor<T>(type, this);
        }


        /**
         * Set an Entity Template
         *
         * @param entityTag
         * @param entityTemplate
         */
        public void setEntityTemplate(string entityTag, IEntityTemplate entityTemplate) {
            entityTemplates[entityTag] = entityTemplate;
        }
        /**
         * Creates a entity from template.
         *
         * @param name
         * @param args
         * @returns {Entity}
         * EntityTemplate
         */
        public Entity createEntityFromTemplate(string name, ...) {
            return entityTemplates[name].buildEntity(createEntity(), this);
        }

    }
        

    class ComponentMapperInitHelper {

        public static void config(EntitySystem target, World world) {

            /**
             * find the Mapper.declaredFields for this system
             * for each:
             *  systemMapper[field] = world.getMapper(componentType)
             */


            
            //  try {
                
            //      var clazz = target.get_type();

            //      for (var fieldIndex in clazz.declaredFields) {
            //          var field = clazz.declaredFields[fieldIndex];
            //          if (!target.hasOwnProperty(field)) {
                        
            //              var componentType = clazz.prototype[field]
            //              target[field] = world.getMapper(componentType);
            //          }
            //      }
                
            //  } catch (e) {
            //      throw new ArtemisException.SettingComponentMappers("for field %s", field);
            //  }


            /**
 class MovementSystem extends EntityProcessingSystem {
     Mapper<Position> positionMapper;
     Mapper<Velocity> velocityMapper;

     MovementSystem() : super(Aspect.getAspectForAllOf([Position, Velocity]));

     void initialize() {
       // initialize your system
       // Mappers, Systems and Managers have to be assigned here
       // see dartemis_transformer if you don't want to write this code
       positionMapper = new Mapper<Position>(Position, world);
       velocityMapper = new Mapper<Velocity>(Velocity, world);
     }

     void processEntity(Entity entity) {
       Position position = positionMapper[entity];
       Velocity vel = velocityMapper[entity];
       position.x += vel.x;
       position.y += vel.y;
     }
 }             * 
             */
        }
    }
    
}

