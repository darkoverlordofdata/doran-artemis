cmake_minimum_required ( VERSION 3.1 )
#########################################################################################
#
#   Library: Microsoft.artemis
#
#########################################################################################
project ( artemis VERSION 0.1.0 )

list ( APPEND SOURCE .lib/artemis/src/Anotations/EntityTemplate.vala )
list ( APPEND SOURCE .lib/artemis/src/Anotations/Mapper.vala )
list ( APPEND SOURCE .lib/artemis/src/Anotations/Pooled.vala )

list ( APPEND SOURCE .lib/artemis/src/Blackboard/Blackboard.vala )
list ( APPEND SOURCE .lib/artemis/src/Blackboard/SimpleTrigger.vala )
list ( APPEND SOURCE .lib/artemis/src/Blackboard/Trigger.vala )
list ( APPEND SOURCE .lib/artemis/src/Blackboard/TriggerMultiCondition.vala )
list ( APPEND SOURCE .lib/artemis/src/Blackboard/TriggerStateType.vala )

list ( APPEND SOURCE .lib/artemis/src/Core/Aspect.vala )
list ( APPEND SOURCE .lib/artemis/src/Core/Component.vala )
list ( APPEND SOURCE .lib/artemis/src/Core/ComponentManager.vala )
list ( APPEND SOURCE .lib/artemis/src/Core/ComponentMapper.vala )
list ( APPEND SOURCE .lib/artemis/src/Core/ComponentPool.vala )
list ( APPEND SOURCE .lib/artemis/src/Core/ComponentType.vala )
list ( APPEND SOURCE .lib/artemis/src/Core/ComponentTypeFactory.vala )
list ( APPEND SOURCE .lib/artemis/src/Core/Entity.vala )
list ( APPEND SOURCE .lib/artemis/src/Core/EntityManager.vala )
list ( APPEND SOURCE .lib/artemis/src/Core/EntityObserver.vala )
list ( APPEND SOURCE .lib/artemis/src/Core/EntitySystem.vala )
list ( APPEND SOURCE .lib/artemis/src/Core/Exceptions.vala )
list ( APPEND SOURCE .lib/artemis/src/Core/IEntityTemplate.vala )
list ( APPEND SOURCE .lib/artemis/src/Core/Manager.vala )
list ( APPEND SOURCE .lib/artemis/src/Core/PooledComponent.vala )
list ( APPEND SOURCE .lib/artemis/src/Core/World.vala )

list ( APPEND SOURCE .lib/artemis/src/Managers/GroupManager.vala )
list ( APPEND SOURCE .lib/artemis/src/Managers/PlayerManager.vala )
list ( APPEND SOURCE .lib/artemis/src/Managers/TagManager.vala )
list ( APPEND SOURCE .lib/artemis/src/Managers/TeamManager.vala )

list ( APPEND SOURCE .lib/artemis/src/Systems/DelayedEntitySystem.vala )
list ( APPEND SOURCE .lib/artemis/src/Systems/EntityProcessingSystem.vala )
list ( APPEND SOURCE .lib/artemis/src/Systems/IntervalEntityProcessingSystem.vala )
list ( APPEND SOURCE .lib/artemis/src/Systems/IntervalEntitySystem.vala )
list ( APPEND SOURCE .lib/artemis/src/Systems/VoidEntitySystem.vala )

list ( APPEND SOURCE .lib/artemis/src/Utils/Bag.vala )
list ( APPEND SOURCE .lib/artemis/src/Utils/BitSet.vala )
list ( APPEND SOURCE .lib/artemis/src/Utils/ImmutableBag.vala )
list ( APPEND SOURCE .lib/artemis/src/Utils/UUID.vala )


## Export to the parent scope:
set ( VALA_SOURCES "${VALA_SOURCES};${SOURCE}" PARENT_SCOPE )
