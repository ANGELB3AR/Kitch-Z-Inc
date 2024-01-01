using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace INab.BetterFog.BIRP
{
    public class CameraDepth : MonoBehaviour
    {
        private void OnEnable()
        {
            var cam = gameObject.GetComponent<Camera>();
            cam.depthTextureMode = DepthTextureMode.Depth;
        }

    }
}