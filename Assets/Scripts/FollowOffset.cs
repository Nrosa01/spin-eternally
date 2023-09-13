using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class FollowOffset : MonoBehaviour
{
    [SerializeField] Transform target;
    Vector3 offset;

    void Start()
    {
        offset = transform.position - target.position; ;
    }

    // Update is called once per frame
    void Update()
    {
        transform.position = target.position + offset;
    }
}
