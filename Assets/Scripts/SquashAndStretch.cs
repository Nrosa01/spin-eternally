using UnityEngine;

public class SquashAndStretch : MonoBehaviour
{
    public Transform cube;
    public Transform parent;
    Vector3 previousPosition;
    public float maxSpeedThreshold;
    public float minSpeedThreshold;
    public float maxStretch = 1.8f;

    float inverseStretch;

    private void Start()
    {
        inverseStretch = 1 / Mathf.Sqrt(maxStretch);
    }

    void Stretch()
    {
        Vector3 velocity = (cube.position - previousPosition) / Time.deltaTime;
        previousPosition = cube.position;
        
        float squashFactor = Mathf.Clamp01(velocity.magnitude / maxSpeedThreshold);
        parent.localScale = Vector3.Lerp(Vector3.one, new Vector3(inverseStretch, maxStretch, inverseStretch), squashFactor);
        parent.rotation = Quaternion.LookRotation(Vector3.forward, velocity.normalized);
    }

    private void Update()
    {
        Stretch();
    }
}
