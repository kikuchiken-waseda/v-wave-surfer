<template>
  <v-card>
    <div ref="stage" v-resize="onResize" />
    <v-card-actions>
      <span> {{ Math.round(current_time * 100) / 100 }} </span>
      <span> / {{ series.length * frame_rate }} </span>
      <span> / {{ sensers.length }} </span>
    </v-card-actions>
  </v-card>
</template>

<script>
import * as THREE from "three";
import * as OrbitControls from "three-orbitcontrols";
export default {
  props: {
    frame_rate: {
      type: Number,
      require: true
    },
    series: {
      type: Array,
      require: true
    }
  },
  data: () => ({
    interval_id: null,
    scene: null,
    renderer: null,
    camera: null,
    controls: null,
    light: null,
    plane: null,
    axes: null,
    sensers: [],
    windowSize: {
      x: 0,
      y: 0
    }
  }),
  computed: {
    current_time: {
      get() {
        return this.$store.state.current_time;
      }
    }
  },
  methods: {
    onResize: function() {
      this.windowSize = {
        x: window.innerWidth * 0.3,
        y: window.innerWidth * 0.3
      };
      if (this.renderer !== null) {
        this.renderer.setSize(this.windowSize.x, this.windowSize.y);
      }
    },
    set_scene: function() {
      this.scene = new THREE.Scene();
    },
    set_rendere: function() {
      this.renderer = new THREE.WebGLRenderer();
      this.renderer.setClearColor(0xffffff, 1.0);
      this.onResize();
    },
    set_cemmera: function() {
      const width = this.windowSize.x;
      const height = this.windowSize.y;
      this.camera = new THREE.PerspectiveCamera(75, width / height, 0.1, 1000);
      this.controls = new OrbitControls(this.camera, this.renderer.domElement);
      this.camera.position.z = 5;
      this.scene.add(this.camera);
    },
    set_light: function() {
      this.light = new THREE.DirectionalLight(0xffffff, 1);
      this.light.position.set(0, 0, 10);
      this.scene.add(this.light);
    },
    set_object: function(data) {
      if (data.size === undefined) {
        data.size = 0.1;
      }
      const geometry = new THREE.SphereGeometry(data.size);
      const material = new THREE.MeshBasicMaterial({
        color: "rgb(0, 150, 136)"
      });
      const mesh = new THREE.Mesh(geometry, material);
      if (data.state == "OK") {
        mesh.position.set(data.t_x, data.t_y, data.t_z);
      } else {
        mesh.position.set(0, 0, 0);
      }
      this.sensers.push({
        id: data.id,
        mesh: mesh
      });
      this.scene.add(mesh);
    },
    set_plane: function() {
      this.plane = new THREE.GridHelper(300, 10, 0x888888, 0x888888);
      this.plane.position.y = -40;
      this.scene.add(this.plane);
    },
    set_axes: function() {
      this.axes = new THREE.AxesHelper(150);
      this.scene.add(this.axes);
    },
    animate: function() {
      const i = Math.round(this.current_time / this.frame_rate);
      const data = this.series[i];
      for (const n in data) {
        const obj = this.sensers.find(x => {
          return x.id == data[n].id;
        });
        const item = data[n];
        if (item.state == "OK") {
          obj.mesh.translateX(item.t_x - obj.mesh.position.x);
          obj.mesh.translateY(item.t_y - obj.mesh.position.y);
          obj.mesh.translateZ(item.t_z - obj.mesh.position.z);
          obj.mesh.material.color.setRGB("rgb(0, 150, 136)");
        } else {
          obj.mesh.material.color.setRGB("rgb(233, 30, 99)");
        }
      }
      this.renderer.render(this.scene, this.camera);
      requestAnimationFrame(this.animate);
    },
    update: function() {
      this.renderer.render(this.scene, this.camera);
      requestAnimationFrame(this.update);
    }
  },
  mounted: function() {
    this.onResize();
    this.$nextTick(() => {
      this.set_scene();
      this.set_rendere();
      this.set_cemmera();
      this.set_light();
      this.set_plane();
      this.set_axes();
      const i = this.series.findIndex(x => {
        return x[0].state == "OK";
      });
      const datas = this.series[i];
      for (const data of datas) {
        this.set_object(data);
      }
      this.$refs.stage.appendChild(this.renderer.domElement);
      this.renderer.render(this.scene, this.camera);
      this.animate();
      this.update();
    });
  }
};
</script>
