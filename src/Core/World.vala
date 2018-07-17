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
using Artemis.Utils;
using Artemis.Annotations;
using System.Collections.Generic;

namespace Artemis {
    

    public delegate void Performer(EntityObserver observer, Entity e);

    public class World {
        private EntityManager em;
        private ComponentManager cm;
    
        private float delta;
        private Bag<Entity> _added;
        private Bag<Entity> _changed;
        private Bag<Entity> _deleted;
        private Bag<Entity> _enable;
        private Bag<Entity> _disable;
    
        private Dictionary<Type, Manager> managers;
        private Bag<Manager> managersBag;
        
        private Dictionary<Type, EntitySystem> systems;
        private Bag<EntitySystem> systemsBag;

        private Dictionary<string, IEntityTemplate> entityTemplates;

        public World() {

            Artemis.Initialize();
            
            managers = new Dictionary<Type, Manager>();
            managersBag = new Bag<Manager>();
            
            systems = new Dictionary<Type, EntitySystem>();
            systemsBag = new Bag<EntitySystem>();
    
            _added = new Bag<Entity>();
            _changed = new Bag<Entity>();
            _deleted = new Bag<Entity>();
            _enable = new Bag<Entity>();
            _disable = new Bag<Entity>();
    
            cm = new ComponentManager();
            SetManager(cm);
            
            em = new EntityManager();
            SetManager(em);
        }
    
        
        /**
         * Makes sure all managers systems are initialized in the order they were added.
        */
        public void Initialize() {
            for (var i = 0; i < managersBag.Size(); i++) {
                managersBag[i].Initialize();
            }
            
            /** 
             * annotaions.EntityTemplate 
             * 
             * Collect the entity templates
             */
            print("init 1\n");
            entityTemplates = new Dictionary<string, IEntityTemplate>();
            print("init 2\n");
            if (EntityTemplate.entityTemplates.Keys != null)
            {
                print("init 3\n");
                foreach (var entityName in EntityTemplate.entityTemplates.Keys) {
                    print("init 4\n");
                    var Template = (Type)EntityTemplate.entityTemplates[entityName];
                    SetEntityTemplate(entityName, (IEntityTemplate)Object.new(Template));
                    print("init 5\n");
                }
            }
            print("init 6\n");
            /** 
             * annotations.Mapper 
             *
             * Collect the component mappers
             */
            for (var i = 0; i < systemsBag.Size(); i++) {
                /** Inject the component mappers into each system */
                ComponentMapperInitHelper.Config(systemsBag[i], this);
                systemsBag[i].Initialize();
            }
        }
        
        
        /**
         * Returns a manager that takes care of all the entities in the world.
         * entities of this world.
         * 
         * @return entity manager.
         */
        public EntityManager GetEntityManager() {
            return em;
        }
        
        /**
         * Returns a manager that takes care of all the components in the world.
        * 
        * @return component manager.
        */
        public ComponentManager GetComponentManager() {
            return cm;
        }
        
        
        
    
        /**
         * Add a manager into this world. It can be retrieved later.
        * World will notify this manager of changes to entity.
        * 
        * @param manager to be added
        */
        public Manager SetManager(Manager manager) {
            managers[manager.get_type()] = manager;
            managersBag.Add(manager);
            manager.SetWorld(this);
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
        public T GetManager<T>(Type managerType) {
            return managers[managerType];
        }
        
        /**
         * Deletes the manager from this world.
        * @param manager to delete.
        */
        public void DeleteManager(Manager manager) {
            managers.Remove(manager.get_type());
            managersBag.Remove(manager);
        }
        
        
        /**
         * Time since last game loop.
        * 
        * @return delta time since last game loop.
        */
        public float GetDelta() {
            return delta;
        }
    
        /**
         * You must specify the delta for the game here.
        * 
        * @param delta time since last game loop.
        */
        public void SetDelta(float delta) {
            delta = delta;
        }
    
    
        /**
         * Adds a entity to this world.
        * 
        * @param e entity
        */
        public void AddEntity(Entity e) {
            _added.Add(e);
        }
        
        /**
         * Ensure all systems are notified of changes to this entity.
        * If you're adding a component to an entity after it's been
        * added to the world, then you need to invoke this method.
        * 
        * @param e entity
        */
        public void ChangedEntity(Entity e) {
            _changed.Add(e);
        }
        
        /**
         * Delete the entity from the world.
        * 
        * @param e entity
        */
        public void DeleteEntity(Entity e) {
            if (!_deleted.Contains(e)) {
                _deleted.Add(e);
            }
        }
    
        /**
         * (Re)enable the entity in the world, after it having being disabled.
        * Won't do anything unless it was already disabled.
        */
        public void Enable(Entity e) {
            _enable.Add(e);
        }
    
        /**
         * Disable the entity from being processed. Won't delete it, it will
        * continue to exist but won't get processed.
        */
        public void Disable(Entity e) {
            _disable.Add(e);
        }
    
    
        /**
         * Create and return a new or reused entity instance.
        * Will NOT add the entity to the world, use World.addEntity(Entity) for that.
        *
        * @param name optional name for debugging
        * @return entity
        */
        public Entity CreateEntity(string name="") {
            return em.CreateEntityInstance(name);
        }
    
        /**
         * Get a entity having the specified id.
        * 
        * @param entityId
        * @return entity
        */
        public Entity GetEntity(int entityId) {
            return em.GetEntity(entityId);
        }
    
    
        /**
         * Gives you all the systems in this world for possible iteration.
        * 
        * @return all entity systems in world.
        */
        public ImmutableBag<EntitySystem> GetSystems() {
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

        public T SetSystem<T>(EntitySystem system, bool passive=false) {
            system.SetWorld(this);
            system.SetPassive(passive);
            
            systems[system.get_type()] = system;
            systemsBag.Add(system);
            
            return system;
        }
        
        /**
         * Removed the specified system from the world.
        * @param system to be deleted from world.
        */
        public void DeleteSystem(EntitySystem system) {
            systems.Remove(system.get_type());
            systemsBag.Remove(system);
        }
        
        private void NotifySystems(Performer perform, Entity e) {
            for (var i = 0, s=systemsBag.Size(); s > i; i++) {
                perform(systemsBag[i], e);
            }
        }
    
        private void NotifyManagers(Performer perform, Entity e) {
            for (var a = 0, s = managersBag.Size(); s > a; a++) {
                perform(managersBag[a], e);
            }
        }
        
        /**
         * Retrieve a system for specified system type.
        * 
        * @param type type of system.
        * @return instance of the system in this world.
        */
        public EntitySystem GetSystem(Type type) {
            return systems[type];
        }

        /**
         * Performs an action on each entity.
        * @param entities
        * @param performer
        */
        private void Check(Bag<Entity> entities, Performer perform) {
            if (!entities.IsEmpty()) {
                for (var i = 0, s = entities.Size(); s > i; i++) {
                    var e = entities[i];
                    NotifyManagers(perform, e);
                    NotifySystems(perform, e);
                }
                entities.Clear();
            }
        }
    
        
        /**
         * Process all non-passive systems.
        */
        public void Process() {

            Check(_added,   (observer, e) => observer.Added(e));
            Check(_changed, (observer, e) => observer.Changed(e));
            Check(_disable, (observer, e) => observer.Disabled(e));
            Check(_enable,  (observer, e) => observer.Enabled(e));
            Check(_deleted, (observer, e) => observer.Deleted(e));
            
            cm.Clean();
            
            for (var i = 0; systemsBag.Size() > i; i++) {
                var system = systemsBag[i];
                if(!system.IsPassive()) {
                    system.Process();
                }
            }
        }
        
    
        /**
         * Retrieves a ComponentMapper instance for fast retrieval of components from entities.
        * 
        * @param type of component to get mapper for.
        * @return mapper for specified component type.
        */
        public ComponentMapper<T> GetMapper<T>(Type type) {
            return ComponentMapper.GetFor<T>(type, this);
        }


        /**
         * Set an Entity Template
         *
         * @param entityTag
         * @param entityTemplate
         */
        public void SetEntityTemplate(string entityTag, IEntityTemplate entityTemplate) {
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
        public Entity CreateEntityFromTemplate(string name, ...) {
            return entityTemplates[name].BuildEntity(CreateEntity(), this);
        }

    }
        

    internal class ComponentMapperInitHelper {

        public static void Config(EntitySystem target, World world) {

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

