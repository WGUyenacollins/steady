--
-- This file is part of Eclipse Steady.
--
-- Licensed under the Apache License, Version 2.0 (the "License");
-- you may not use this file except in compliance with the License.
-- You may obtain a copy of the License at
--
--     http://www.apache.org/licenses/LICENSE-2.0
--
-- Unless required by applicable law or agreed to in writing, software
-- distributed under the License is distributed on an "AS IS" BASIS,
-- WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
-- See the License for the specific language governing permissions and
-- limitations under the License.
--
-- SPDX-License-Identifier: Apache-2.0
--
-- Copyright (c) 2018 SAP SE or an SAP affiliate company. All rights reserved.
--

create table app (id int8 not null, artifact varchar(128) not null, created_at timestamp, mvn_group varchar(128) not null, version varchar(32) not null, primary key (id));
create table app_constructs (app_id int8 not null, constructs_id int8 not null);
create table app_dependency (id int8 not null, declared boolean, filename varchar(255), scope varchar(255), traced boolean, transitive boolean, app int8 not null, lib varchar(64) not null, primary key (id));
create table app_dependency_reachable_construct_ids (app_dependency_id int8 not null, reachable_construct_ids_id int8 not null);
create table app_dependency_touch_points (id int8 not null, direction varchar(255) not null, from_construct_id int8 not null, source varchar(255) not null, to_construct_id int8 not null, primary key (id, direction, from_construct_id, source, to_construct_id));create table app_goal_exe (id int8 not null, client_version varchar(255), created_at timestamp, exception varchar(255), execution_id varchar(255), goal varchar(9) not null, mem_max int8, mem_used_avg int8, mem_used_max int8, runtime_nano int8, started_at_client timestamp, app int8 not null, primary key (id));
create table app_goal_exe_configuration (app_goal_exe_id int8 not null, configuration_id int8 not null);
create table app_goal_exe_statistics (goal_execution_id int8 not null, statistics int8, statistics_key varchar(255), primary key (goal_execution_id, statistics_key));
create table app_goal_exe_system_info (app_goal_exe_id int8 not null, system_info_id int8 not null);
create table app_path (id int8 not null, execution_id varchar(255), source varchar(255), app int8 not null, bug varchar(32) not null, end_construct_id int8 not null, lib varchar(64), start_construct_id int8 not null, primary key (id));
create table app_path_path (id int8 not null, construct_id int8 not null, lib varchar(64), path_order int4 not null, primary key (id, path_order));
create table app_trace (id int8 not null, count int4, execution_id varchar(255), traced_at timestamp, app int8 not null, construct_id int8 not null, lib varchar(64), primary key (id));
create table bug (id int8 not null, bug_id varchar(32) not null, created_at timestamp, created_by varchar(255), description text, modified_at timestamp, modified_by varchar(255), source varchar(255), url varchar(1024), primary key (id));
create table bug_affected_construct_change (id int8 not null, affected boolean, ast_equal varchar(255), class_in_archive boolean, dtf int4, dtv int4, equal_change_type boolean, in_archive boolean, overall_chg int4, tested_body text, affected_lib int8 not null, bug_construct_change int8 not null, primary key (id));
create table bug_affected_library (id int8 not null, affected boolean not null, created_at timestamp, created_by varchar(255), explanation text, first_fixed varchar(255), from_intersection varchar(255), last_vulnerable varchar(255), source varchar(255) not null, to_intersection varchar(255), bug_id varchar(32) not null, lib varchar(64), library_id int8, primary key (id));
create table bug_construct_change (id int8 not null, body_change text, buggy_body text, commit varchar(255), committed_at timestamp, construct_change_type varchar(3) not null, fixed_body text, repo varchar(255), repo_path varchar(255), bug varchar(32) not null, construct_id int8 not null, primary key (id));
create table construct_id (id int8 not null, lang varchar(4) not null, qname varchar(2048) not null, type varchar(4) not null, primary key (id));
create table lib (id int8 not null, created_at timestamp, sha1 varchar(64) not null, wellknown_sha1 boolean, library_id_id int8, primary key (id));create table lib_constructs (lib_id int8 not null, constructs_id int8 not null);
create table lib_properties (lib_id int8 not null, properties_id int8 not null);
create table library_id (id int8 not null, artifact varchar(512) not null, mvn_group varchar(512) not null, version varchar(128) not null, primary key (id));
create table property (id int8 not null, name varchar(1024) not null, property_value text not null, source varchar(255) not null, value_sha1 varchar(255) not null, primary key (id));
alter table app add constraint UK_apcod7vgdms2hvqj0r88hg5is unique (mvn_group, artifact, version);
alter table app_dependency add constraint UK_bp7iv9k79w4galqwpris6yedl unique (lib, app);
alter table app_goal_exe add constraint UK_j11sgtekfs7nvk1gtrl3ggxa3 unique (app, goal, started_at_client);
alter table app_path add constraint UK_5y9rxpo8rl02jln7ryesxp8oh unique (app, bug, source, lib, start_construct_id, end_construct_id);
alter table app_trace add constraint UK_r0ddxxxag6mv2yatxkuj31t9n unique (app, lib, construct_id);
alter table bug add constraint bugId_index unique (bug_id);
alter table bug_affected_library add constraint UK_scfythjql9tt4afpjuh337oju unique (bug_id, library_id, source);
alter table bug_affected_library add constraint UK_r4g43rr5dug4pla8jmfbn9ccr unique (bug_id, lib, source);
alter table bug_construct_change add constraint UK_to1f1lr4yaj18032625p4knn0 unique (bug, repo, commit, repo_path, construct_id);
alter table construct_id add constraint UK_3go88sqfp92btbhuxygdo9m62 unique (lang, type, qname);
create index cid_lang_index on construct_id (lang);
create index cid_type_index on construct_id (type);
create index cid_qname_index on construct_id (qname);
create index cid_index on construct_id (lang, type, qname);
alter table lib add constraint sha1_index unique (sha1);
alter table library_id add constraint UK_liegdseckq1w5qj822cjs84r0 unique (mvn_group, artifact, version);
alter table property add constraint UK_k4t1h8l3h8y2o86yjxce3qmd9 unique (source, name, value_sha1);
alter table app_constructs add constraint FK_h47hsv2r1pdicng39emhhxmtg foreign key (constructs_id) references construct_id;
alter table app_constructs add constraint FK_4wkubfu8dbcowq7vwxesfr78w foreign key (app_id) references app;
alter table app_dependency add constraint FK_u3hdeg07l4howhc07hmy1mk2 foreign key (app) references app;
alter table app_dependency add constraint FK_3mlqqni3f6jkaqocyr6hmwk99 foreign key (lib) references lib (sha1);
alter table app_dependency_reachable_construct_ids add constraint FK_2jd4jp00y9e6agxmjobraqadw foreign key (reachable_construct_ids_id) references construct_id;
alter table app_dependency_reachable_construct_ids add constraint FK_poragrc9uphn62u9n5ckcw7rk foreign key (app_dependency_id) references app_dependency;
alter table app_dependency_touch_points add constraint FK_bun1ayax18wu6fk614hsocmvb foreign key (from_construct_id) references construct_id;
alter table app_dependency_touch_points add constraint FK_jdm5c0k5hb2royytvjmkgn1m7 foreign key (to_construct_id) references construct_id;
alter table app_dependency_touch_points add constraint FK_pyk7qayfdas9f6rqpqq6lkmob foreign key (id) references app_dependency;
alter table app_goal_exe add constraint FK_g0802go7c1fyu84cdlxcqw2lk foreign key (app) references app;
alter table app_goal_exe_configuration add constraint FK_a6nlp4yrovlxu1hfx5tuwnfym foreign key (configuration_id) references property;
alter table app_goal_exe_configuration add constraint FK_54y8i6larbupn4gf2r7getu1i foreign key (app_goal_exe_id) references app_goal_exe;
alter table app_goal_exe_statistics add constraint FK_iit70lr3mb88crkv0dyhbkqob foreign key (goal_execution_id) references app_goal_exe;
alter table app_goal_exe_system_info add constraint FK_6du04ielh5wg8alg83s17jiyc foreign key (system_info_id) references property;
alter table app_goal_exe_system_info add constraint FK_ayiulk80l528x5ogndl8saafx foreign key (app_goal_exe_id) references app_goal_exe;
alter table app_path add constraint FK_qso9opcp4flrrn9p1c4crou9c foreign key (app) references app;
alter table app_path add constraint FK_5c2inefuuw0gjl8r26ecwsafp foreign key (bug) references bug (bug_id);
alter table app_path add constraint FK_7h30fx3yc59q56knty7t33wlj foreign key (end_construct_id) references construct_id;
alter table app_path add constraint FK_fitmj70jike9xsrr5gisuh3gs foreign key (lib) references lib (sha1);
alter table app_path add constraint FK_r1okg9en9y4194ndmjstpw5nv foreign key (start_construct_id) references construct_id;
alter table app_path_path add constraint FK_qxer1tis3iutifb5gn7k2av30 foreign key (construct_id) references construct_id;
alter table app_path_path add constraint FK_sgpx08w3s0u2ukd2wq270wrvt foreign key (lib) references lib (sha1);
alter table app_path_path add constraint FK_2shihav8njyavnf7mq7jqmhrj foreign key (id) references app_path;
alter table app_trace add constraint FK_cjl56oenbt3wb0bsh9ryje5yw foreign key (app) references app;
alter table app_trace add constraint FK_7kj7j0b1qq0j9x0fymkawomtc foreign key (construct_id) references construct_id;
alter table app_trace add constraint FK_1353i6occf8ric1hxt80s0mhr foreign key (lib) references lib (sha1);
alter table bug_affected_construct_change add constraint FK_7dap5l5oskn621gbnfh5fbhc9 foreign key (affected_lib) references bug_affected_library;
alter table bug_affected_construct_change add constraint FK_49ig9c71ttnmsowf1v6yx36v0 foreign key (bug_construct_change) references bug_construct_change;
alter table bug_affected_library add constraint FK_jr7v0rk9ghvlpa8xxwghql4pf foreign key (bug_id) references bug (bug_id);
alter table bug_affected_library add constraint FK_95etulg7h15qv5n5p1gmgwdoq foreign key (lib) references lib (sha1);
alter table bug_affected_library add constraint FK_57ldgkgmrn98wtkrp8k7tnwe foreign key (library_id) references library_id;
alter table bug_construct_change add constraint FK_je25e065sm3y8yv48jgsfvr2h foreign key (bug) references bug (bug_id);
alter table bug_construct_change add constraint FK_6bpg570tuwe3febcd8gflu2bl foreign key (construct_id) references construct_id;
alter table lib add constraint FK_y66eipsxk2mhkdopivh9f4rn foreign key (library_id_id) references library_id;
alter table lib_constructs add constraint FK_pfk33vengljm5qa5bkfsp56vn foreign key (constructs_id) references construct_id;
alter table lib_constructs add constraint FK_bw52upww33wdps6dyoci414ce foreign key (lib_id) references lib;
alter table lib_properties add constraint FK_3guxrk4xk40qqj3h50nrxsvxu foreign key (properties_id) references property;
alter table lib_properties add constraint FK_4uiuwnr7xovmt8iag2k2800v2 foreign key (lib_id) references lib;
create sequence hibernate_sequence;
