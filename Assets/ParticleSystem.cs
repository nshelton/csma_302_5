using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ParticleSystem : MonoBehaviour
{

    struct Particle
    {
        public Vector3 position; //12 bytes :4 bytes per float * 3 floats
        public Vector3 velocity; //12 bytes :4 bytes per float * 3 floats
        public float age; //4 bytes
    } // 28 bytes

    private const int PARTICLE_BYTES = 28;

    ComputeBuffer _particleBuffer;

    [SerializeField] public int _numParticles = 10000;
    [SerializeField, Range(0.1f, 10)] public float _maxAge = 5;
    [SerializeField] public Vector3 _initialVelocity = new Vector3(0,1,0);

    [SerializeField] Material _particleMaterial;
    [SerializeField] ComputeShader _particleSimulation;

    [SerializeField] public float _noiseAmplitude;
    [SerializeField] public float _noiseFrequency;
    [SerializeField] public float _noiseSpeed;
    [SerializeField, Range(0.1f, 1f)] public float _drag;

    private int _kernelId;

    void Start()
    {
        // create buffer on GPU
        _particleBuffer = new ComputeBuffer(_numParticles, PARTICLE_BYTES);

        // create buffer on CPU
        Particle[] cpuParticles = new Particle[_numParticles];

        for(int i = 0; i < _numParticles; i ++)
        {
            cpuParticles[i].age = _maxAge;
            cpuParticles[i].position = new Vector3(Random.value, Random.value, Random.value);
            cpuParticles[i].velocity = new Vector3(Random.value, Random.value, Random.value);
        }

        // Upload the data to GPU
        _particleBuffer.SetData(cpuParticles);

        _particleMaterial.SetBuffer("_Particles", _particleBuffer);

        _kernelId = _particleSimulation.FindKernel("CSMain");
        _particleSimulation.SetBuffer(_kernelId, "_Particles", _particleBuffer);
    }

    private void OnDestroy()
    {
        if(_particleBuffer != null)
        {
            _particleBuffer.Release();
        }    
    }

    void OnRenderObject()
    {
        _particleMaterial.SetPass(0);
        Graphics.DrawProceduralNow(MeshTopology.Points, 1, _numParticles);
    }

    private void Update()
    {
        _particleSimulation.SetFloat("_dt", Time.deltaTime);
        _particleSimulation.SetFloat("_time", Time.time);
        _particleSimulation.SetFloat("_maxAge", _maxAge);
        _particleSimulation.SetVector("_initialVelocity", _initialVelocity);

        _particleSimulation.SetFloat("_noiseAmplitude", _noiseAmplitude);
        _particleSimulation.SetFloat("_noiseFrequency", _noiseFrequency);
        _particleSimulation.SetFloat("_noiseSpeed", _noiseSpeed);
        _particleSimulation.SetFloat("_drag", _drag);

        _particleSimulation.Dispatch(_kernelId, Mathf.CeilToInt((float)_numParticles / 128f), 1, 1);
    }
}
