-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE analisar_migr_proj_dbgrid ( cd_funcao_p bigint, nm_objeto_p text, ie_impl_after_open_p text, ie_impl_after_scroll_p text, ie_impl_before_post_p text, ie_impl_dbclick_p text, ie_impl_draw_column_cell_p text, ie_impl_enter_p text, ie_impl_exit_p text, ie_impl_keypress_p text, nm_usuario_p text) AS $body$
DECLARE


nr_sequencia_w			bigint;
--qt_impl_after_cancel_w		number(10,0) := 20;
qt_impl_after_open_w		bigint := 15;
--qt_impl_after_post_w		number(10,0) := 90;
qt_impl_after_scroll_w		bigint := 30;
--qt_impl_before_delete_w		number(10,0) := 20;
--qt_impl_before_edit_w		number(10,0) := 30;
--qt_impl_before_insert_w		number(10,0) := 15;
qt_impl_before_post_w		bigint := 30;
--qt_impl_atrib_change_w		number(10,0) := 90;
--qt_impl_atrib_change_w		number(10,0) := 60;
--qt_impl_atrib_dbclick_w		number(10,0) := 30;
--qt_impl_atrib_enter_w		number(10,0) := 30;
--qt_impl_atrib_exit_w		number(10,0) := 90;
--qt_impl_atrib_exit_w		number(10,0) := 60;
--qt_impl_atrib_keypress_w	number(10,0) := 15;
--qt_impl_checkbox_click_w	number(10,0) := 30;
--qt_impl_dbclick_w		number(10,0) := 30;
qt_impl_dbclick_w		bigint := 15;
--qt_impl_draw_column_cell_w	number(10,0) := 60;
qt_impl_draw_column_cell_w	bigint := 30;
qt_impl_enter_w			bigint := 10;
qt_impl_exit_w			bigint := 10;
--qt_impl_final_panel_w		number(10,0) := 15;
--qt_impl_grid_dbclick_w		number(10,0) := 20;
--qt_impl_grid_title_click_w	number(10,0) := 15;
--qt_impl_new_record_w		number(10,0) := 120;
--qt_impl_new_record_w		number(10,0) := 90;
qt_impl_abrir_consulta_w	bigint := 0;
qt_impl_fechar_consulta_w	bigint := 0;
qt_impl_keypress_w		bigint := 5;
qt_tempo_desenv_w		bigint := 90;


BEGIN
if (ie_impl_after_open_p = 'S') then
	begin
	qt_tempo_desenv_w := qt_tempo_desenv_w + qt_impl_after_open_w;
	end;
end if;
if (ie_impl_after_scroll_p = 'S') then
	begin
	qt_tempo_desenv_w := qt_tempo_desenv_w + qt_impl_after_scroll_w;
	end;
end if;
if (ie_impl_before_post_p = 'S') then
	begin
	qt_tempo_desenv_w := qt_tempo_desenv_w + qt_impl_before_post_w;
	end;
end if;
if (ie_impl_dbclick_p = 'S') then
	begin
	qt_tempo_desenv_w := qt_tempo_desenv_w + qt_impl_dbclick_w;
	end;
end if;
if (ie_impl_draw_column_cell_p = 'S') then
	begin
	qt_tempo_desenv_w := qt_tempo_desenv_w + qt_impl_draw_column_cell_w;
	end;
end if;
if (ie_impl_enter_p = 'S') then
	begin
	qt_tempo_desenv_w := qt_tempo_desenv_w + qt_impl_enter_w;
	end;
end if;
if (ie_impl_exit_p = 'S') then
	begin
	qt_tempo_desenv_w := qt_tempo_desenv_w + qt_impl_exit_w;
	end;
end if;
if (ie_impl_keypress_p = 'S') then
	begin
	qt_tempo_desenv_w := qt_tempo_desenv_w + qt_impl_keypress_w;
	end;
end if;


select	nextval('w_analise_migr_proj_seq')
into STRICT	nr_sequencia_w
;

insert into w_analise_migr_proj(
	nr_sequencia,
	dt_atualizacao_nrec,
	nm_usuario_nrec,
	dt_atualizacao,
	nm_usuario,
	cd_funcao,
	ie_objeto,
	nm_objeto,
	ds_objeto,
	impl_after_open,
	impl_after_scroll,
	impl_before_post,
	impl_dbclick,
	impl_draw_column_cell,
	impl_enter,
	impl_exit,
	impl_keypress,
	qt_tempo_desenv)
values (
	nr_sequencia_w,
	clock_timestamp(),
	nm_usuario_p,
	clock_timestamp(),
	nm_usuario_p,
	cd_funcao_p,
	'TDBGrid',
	nm_objeto_p,
	null,
	ie_impl_after_open_p,
	ie_impl_after_scroll_p,
	ie_impl_before_post_p,
	ie_impl_dbclick_p,
	ie_impl_draw_column_cell_p,
	ie_impl_enter_p,
	ie_impl_exit_p,
	ie_impl_keypress_p,
	qt_tempo_desenv_w);
commit;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE analisar_migr_proj_dbgrid ( cd_funcao_p bigint, nm_objeto_p text, ie_impl_after_open_p text, ie_impl_after_scroll_p text, ie_impl_before_post_p text, ie_impl_dbclick_p text, ie_impl_draw_column_cell_p text, ie_impl_enter_p text, ie_impl_exit_p text, ie_impl_keypress_p text, nm_usuario_p text) FROM PUBLIC;

