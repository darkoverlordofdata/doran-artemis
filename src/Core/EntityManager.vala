using Artemis.Utils;

namespace Artemis {

	public class EntityManager : Manager {
		private Bag<Entity> entities;
		private BitSet _disabled;
		
		private int _active;
		private int _added;
		private int _created;
		private int _deleted;
	
		private IdentifierPool identifierPool;
		
		public EntityManager() {
			base();
			entities = new Bag<Entity>();
			_disabled = new BitSet();
			identifierPool = new IdentifierPool();
			_active = 0;
            _added = 0;
            _created = 0;
            _deleted = 0;
		}
		
		
		public override void initialize() {}
	
		public Entity createEntityInstance(string name = "") {
			var e = new Entity(world, identifierPool.checkOut(), name);
			_created++;
			return e;
		}
		
		
		public void added(Entity e) {
			_active++;
			_added++;
			entities.set(e.getId(), e);
		}
		
		
		public void enabled(Entity e) {
			_disabled.clear(e.getId());
		}
		
		
		public void disabled(Entity e) {
			_disabled.set(e.getId());
		}
		
		
		public void deleted(Entity e) {
			entities.set(e.getId(), null);
			
			_disabled.clear(e.getId());
			
			identifierPool.checkIn(e.getId());
			
			_active--;
			_deleted++;
		}
	
	
		/**
		* Check if this entity is active.
		* Active means the entity is being actively processed.
		* 
		* @param entityId
		* @return true if active, false if not.
		*/
		public bool isActive(int entityId) {
			return entities[entityId] != null;
		}
		
		/**
		* Check if the specified entityId is enabled.
		* 
		* @param entityId
		* @return true if the entity is enabled, false if it is disabled.
		*/
		public bool isEnabled(int entityId) {
			return !_disabled.get(entityId);
		}
		
		/**
		* Get a entity with this id.
		* 
		* @param entityId
		* @return the entity
		*/
		public Entity getEntity(int entityId) {
			return entities[entityId];
		}
		
		/**
		* Get how many entities are active in this world.
		* @return how many entities are currently active.
		*/
		public int getActiveEntityCount() {
			return _active;
		}
		
		/**
		* Get how many entities have been created in the world since start.
		* Note: A created entity may not have been added to the world, thus
		* created count is always equal or larger than added count.
		* @return how many entities have been created since start.
		*/
		public int getTotalCreated() {
			return _created;
		}
		
		/**
		* Get how many entities have been added to the world since start.
		* @return how many entities have been added.
		*/
		public int getTotalAdded() {
			return _added;
		}
		
		/**
		* Get how many entities have been deleted from the world since start.
		* @return how many entities have been deleted since start.
		*/
		public int getTotalDeleted() {
			return _deleted;
		}
		
		
		
	
	}
	/*
	* Used only internally to generate distinct ids for entities and reuse them.
	*/
	class IdentifierPool {
		private Bag<int> ids;
		private int nextAvailableId=0;

		public IdentifierPool() {
			ids = new Bag<int>();
		}
		
		public int checkOut() {
			if (ids.size() > 0) {
				return ids.removeLast();
			}
			return nextAvailableId++;
		}
		
		public void checkIn(int id) {
			ids.add(id);
		}
	}
}

