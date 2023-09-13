using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class FollowMouse : MonoBehaviour
{
    Camera main;

    void Awake() => main = Camera.main;

    void Update() => transform.position = main.ScreenToWorldPoint(Input.mousePosition);
}
