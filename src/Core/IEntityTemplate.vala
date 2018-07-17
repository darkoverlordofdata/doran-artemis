namespace Artemis {
  
    public interface IEntityTemplate : Object {
        public abstract Entity BuildEntity(Entity entity, World world, ...);
    }
  
}