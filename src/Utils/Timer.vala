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
namespace Artemis.Utils 
{
    public delegate void TimerExecute();

    public class Timer : Object
    {
        private float delay;
        private bool repeat;
        private float acc;
        private bool done;
        private bool stopped;

        public Timer(float delay, bool repeat = false)
        {
            this.delay = delay;
            this.repeat = repeat;
            this.acc = 0;
        }

        /** Simulate an anonymous abstract class */
        public TimerExecute Execute = () => 
        { 

        };

        public void Update(float delta) {
            if (!done && !stopped) {
                acc += delta;

                if (acc >= delay) {
                    acc -= delay;

                    if (repeat) {
                        Reset();
                    } else {
                        done = true;
                    }

                    Execute();
                }
            }
        }

        public void Reset() {
            stopped = false;
            done = false;
            acc = 0;
        }

        public bool IsDone() {
            return done;
        }

        public bool IsRunning() {
            return !done && acc < delay && !stopped;
        }

        public void Stop() {
            stopped = true;
        }

        public void SetDelay(int delay) {
            this.delay = delay;
        }

        // public virtual void Execute()
        // {
        //     if (ex != null) ex();
        // }

        public float GetPercentageRemaining() {
            if (done)
                return 100;
            else if (stopped)
                return 0;
            else
                return 1 - (delay - acc) / delay;
        }

        public float GetDelay() {
            return delay;
        }


    }
}