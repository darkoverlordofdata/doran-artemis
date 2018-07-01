namespace Artemis {
  
    public interface IEntityTemplate : Object {
        public abstract Entity buildEntity(Entity entity, World world, ...);
    }
  
}