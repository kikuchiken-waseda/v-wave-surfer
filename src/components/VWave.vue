<template>
  <v-card>
    <div ref="stage" v-resize="onResize" />
    <v-card-actions>
      <v-btn icon @click="play()">
        <v-icon>{{ this.play_icon }}</v-icon>
      </v-btn>
      <v-spacer></v-spacer>
      <span> {{ Math.round(current_time * 100) / 100 }} </span>
    </v-card-actions>
  </v-card>
</template>

<script>
import * as THREE from "three";
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
    current_time: 0,
    current_frame: 0,
    is_playing: false,
    interval_id: null,
    scene: null,
    renderer: null,
    camera: null,
    light: null,
    plane: null,
    axes: null,
    objects: [],
    windowSize: {
      x: 0,
      y: 0
    }
  }),
  computed: {
    play_icon() {
      if (this.is_playing) {
        return "pause";
      }
      return "play_arrow";
    }
  },
  methods: {
    onResize() {
      this.windowSize = {
        x: window.innerWidth * 0.2,
        y: window.innerWidth * 0.2
      };
      if (this.renderer !== null) {
        this.renderer.setSize(this.windowSize.x, this.windowSize.y);
      }
    },
    set_scene() {
      this.scene = new THREE.Scene();
    },
    set_rendere() {
      this.renderer = new THREE.WebGLRenderer();
      this.renderer.setClearColor(0xffffff, 1.0);
      this.onResize();
    },
    set_cemmera() {
      const width = this.windowSize.x;
      const height = this.windowSize.y;
      this.camera = new THREE.PerspectiveCamera(75, width / height, 0.1, 1000);
      this.camera.position.z = 5;
      this.scene.add(this.camera);
    },
    set_light() {
      this.light = new THREE.DirectionalLight(0xffffff, 1);
      this.light.position.set(0, 0, 10);
      this.scene.add(this.light);
    },
    set_object(obj) {
      if (obj.size === undefined) {
        obj.size = 0.1;
      }
      const geometry = new THREE.SphereGeometry(obj.size);
      const material = new THREE.MeshLambertMaterial({ color: 0x6699ff });
      const mesh = new THREE.Mesh(geometry, material);
      mesh.position.set(obj.x, obj.y, obj.z);
      this.objects.push(mesh);
      this.scene.add(mesh);
    },
    set_plane() {
      this.plane = new THREE.GridHelper(300, 10, 0x888888, 0x888888);
      this.plane.position.y = -40;
      this.scene.add(this.plane);
    },
    set_axes() {
      this.axes = new THREE.AxesHelper(150);
      this.scene.add(this.axes);
    },
    animate() {
      const i = this.current_frame % this.series.length;
      const data = this.series[i];
      for (const n in data) {
        const obj = this.objects[n];
        const item = data[n];
        obj.translateX(item.x - obj.position.x);
        obj.translateY(item.y - obj.position.y);
        obj.translateZ(item.z - obj.position.z);
      }
      this.renderer.render(this.scene, this.camera);
    },
    play: function() {
      if (this.is_playing) {
        this.current_time = 0;
        this.current_frame = 0;
        clearInterval(this.interval_id);
        this.is_playing = false;
      } else {
        let self = this;
        this.interval_id = setInterval(function() {
          self.current_frame += 1;
          self.current_time += self.frame_rate;
          self.animate();
        }, this.frame_rate * 1000);
        this.is_playing = true;
      }
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

      const datas = this.series[0];
      for (const data of datas) {
        this.set_object(data);
      }
      this.$refs.stage.appendChild(this.renderer.domElement);
      this.renderer.render(this.scene, this.camera);
      // this.play();
    });
  },
  beforeDestroy() {
    if (clearInterval !== null) {
      clearInterval(this.interval_id);
    }
  }
};
</script>

<style scoped></style>
