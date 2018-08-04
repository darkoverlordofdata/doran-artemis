/* ******************************************************************************
 * Copyright 2018 darkoverlordofdata.
 * 
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * 
 *   http://www.apache.org/licenses/LICENSE-2.0
 * 
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 ******************************************************************************/
namespace Artemis 
{
    // using Artemis.Annotations;
    using System.Collections.Generic;
    // public class Ecs : Object
    namespace Annotations
    {
        public static void Register<G>(Dictionary<string?,Type> dict, ...)
        {
            var p = va_list();
            while (true)
            {
                var name = p.arg<string?>();
                if (name == null) break;

                var object = p.arg<Type>();
                if (!object.is_a(typeof(G)))
                    throw new Artemis.Exception.InvalidType("%s Not Found".printf(typeof(G).name()));
                dict[name] = object;  
            }
        }        
        public static G[] ArrayOf<G>(G elem, ...)
        {
            var p = va_list();
            G[] a = { elem };

            while (true)
            {
                var object = p.arg<G?>();
                if (object == null) break;

                a.resize(a.length+1);
                a[a.length-1] = object;
            }
            return a;
        } 
        public static void Registerz<G>(Dictionary<string?,Type> dict, ...)
        {
            // var p = va_list();
            // while (true)
            // {
            //     var name = p.arg<string?>();
            //     if (name == null) break;

            //     var object = p.arg<Type>();
            //     if (!object.is_a(typeof(G)))
            //         throw new Artemis.Exception.InvalidType("%s Not Found".printf(typeof(G).name()));
            //     dict[name] = object;  
            // }
        }        
    }
}