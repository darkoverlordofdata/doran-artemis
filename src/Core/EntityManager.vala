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
		
		
		public override void Initialize() {}
	
		public Entity CreateEntityInstance(string name = "") {
			var e = new Entity(world, identifierPool.CheckOut(), name);
			_created++;
			return e;
		}
		
		
		public override void Added(Entity e) {
			_active++;
			_added++;
			entities.set(e.GetId(), e);
		}
		
		
		public override void Enabled(Entity e) {
			_disabled.Clear(e.GetId());
		}
		
		
		public override void Disabled(Entity e) {
			_disabled[e.GetId()] = true;
		}
		
		
		public override void Deleted(Entity e) {
			entities.set(e.GetId(), null);
			
			_disabled.Clear(e.GetId());
			
			identifierPool.CheckIn(e.GetId());
			
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
		public bool IsActive(int entityId) {
			return entities[entityId] != null;
		}
		
		/**
		* Check if the specified entityId is enabled.
		* 
		* @param entityId
		* @return true if the entity is enabled, false if it is disabled.
		*/
		public bool IsEnabled(int entityId) {
			return !_disabled.get(entityId);
		}
		
		/**
		* Get a entity with this id.
		* 
		* @param entityId
		* @return the entity
		*/
		public Entity GetEntity(int entityId) {
			return entities[entityId];
		}
		
		/**
		* Get how many entities are active in this world.
		* @return how many entities are currently active.
		*/
		public int GetActiveEntityCount() {
			return _active;
		}
		
		/**
		* Get how many entities have been created in the world since start.
		* Note: A created entity may not have been added to the world, thus
		* created count is always equal or larger than added count.
		* @return how many entities have been created since start.
		*/
		public int GetTotalCreated() {
			return _created;
		}
		
		/**
		* Get how many entities have been added to the world since start.
		* @return how many entities have been added.
		*/
		public int GetTotalAdded() {
			return _added;
		}
		
		/**
		* Get how many entities have been deleted from the world since start.
		* @return how many entities have been deleted since start.
		*/
		public int GetTotalDeleted() {
			return _deleted;
		}
	}
	/*
	* Used only internally to generate distinct ids for entities and reuse them.
	*/
	internal class IdentifierPool {
		private Bag<int> ids;
		private int nextAvailableId=0;

		public IdentifierPool() {
			ids = new Bag<int>();
		}
		
		public int CheckOut() {
			if (ids.Size() > 0) {
				return ids.RemoveLast();
			}
			return nextAvailableId++;
		}
		
		public void CheckIn(int id) {
			ids.Add(id);
		}
	}
}

