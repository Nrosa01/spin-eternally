using UnityEngine;
using UnityEngine.XR;

public class SquashAndStretch : MonoBehaviour
{
    Transform parent;
    Transform grandParent;
    Vector3 previousPosition;
    public float maxSpeed;
    public float maxStretch = 1.8f;

    float inverseStretch;

    private void Start()
    {
        inverseStretch = 1 / Mathf.Sqrt(maxStretch);
        parent = transform.parent;
        grandParent = parent.parent;
    }

    void Stretch()
    {
        parent.position = grandParent.position;
        Vector3 velocity = (transform.position - previousPosition) / Time.deltaTime;
        float stretchFactor = Mathf.Clamp01(velocity.magnitude / maxSpeed);
        parent.localScale = Vector3.Lerp(Vector3.one, new Vector3(inverseStretch, inverseStretch, maxStretch), stretchFactor);
        previousPosition = transform.position;
        parent.LookAt(parent.position + velocity);
        transform.rotation = grandParent.rotation;
    }

    private void Update()
    {
        Stretch();
    }
}
