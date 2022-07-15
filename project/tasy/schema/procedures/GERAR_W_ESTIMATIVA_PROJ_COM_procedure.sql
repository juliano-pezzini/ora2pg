-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_w_estimativa_proj_com ( nr_seq_cliente_p bigint default 0, cd_consultor_p text default 'N', dt_ini_prev_p timestamp default null, ie_opcao_p text DEFAULT NULL, ie_mes_p bigint default 0, qt_hora_dia_p bigint default 0, nr_seq_mod_p bigint default 0, nm_usuario_p text DEFAULT NULL) AS $body$
DECLARE


/*ie_opcao_p
C- Cliente
D- Deletar tabela full table
E - Estimativa
R - data Referencia*/
nr_sequencia_w		bigint;


BEGIN
if (ie_opcao_p = 'C') then
	begin
	select	coalesce(max(nr_sequencia),0)+1
	into STRICT	nr_sequencia_w
	from	w_estimativa_proj_com;
	insert	into w_estimativa_proj_com(	nr_sequencia,
											nr_seq_cliente,
											cd_consultor,
											nr_seq_modulo,
											vl_mes_01,
											vl_mes_02,
											vl_mes_03,
											vl_mes_04,
											vl_mes_05,
											vl_mes_06,
											vl_mes_07,
											vl_mes_08,
											vl_mes_09,
											vl_mes_10,
											vl_mes_11,
											vl_mes_12)
									values (nr_sequencia_w,
											nr_seq_cliente_p,
											cd_consultor_p,
											nr_seq_mod_p,
											0,0,0,0,0,0,0,0,0,0,0,0);
	if (ie_mes_p = 1) then
		begin
		update	w_estimativa_proj_com
		set		vl_mes_01 = coalesce(coalesce(vl_mes_01,0)+qt_hora_dia_p,0),
				dt_mes_01 = dt_ini_prev_p
		where	nr_sequencia = nr_sequencia_w;
		end;
	elsif (ie_mes_p = 2) then
		begin
		update	w_estimativa_proj_com
		set		vl_mes_02 = coalesce(coalesce(vl_mes_02,0)+qt_hora_dia_p,0),
				dt_mes_02 = dt_ini_prev_p
		where	nr_sequencia = nr_sequencia_w;
		end;
	elsif (ie_mes_p = 3) then
		begin
		update	w_estimativa_proj_com
		set		vl_mes_03 = coalesce(coalesce(vl_mes_03,0)+qt_hora_dia_p,0),
				dt_mes_03 = dt_ini_prev_p
		where	nr_sequencia = nr_sequencia_w;
		end;
	elsif (ie_mes_p = 4) then
		begin
		update	w_estimativa_proj_com
		set		vl_mes_04 = coalesce(coalesce(vl_mes_04,0)+qt_hora_dia_p,0),
				dt_mes_04 = dt_ini_prev_p
		where	nr_sequencia = nr_sequencia_w;
		end;
	elsif (ie_mes_p = 5) then
		begin
		update	w_estimativa_proj_com
		set		vl_mes_05 = coalesce(coalesce(vl_mes_05,0)+qt_hora_dia_p,0),
				dt_mes_05 = dt_ini_prev_p
		where	nr_sequencia = nr_sequencia_w;
		end;
	elsif (ie_mes_p = 6) then
		begin
		update	w_estimativa_proj_com
		set		vl_mes_06 = coalesce(coalesce(vl_mes_06,0)+qt_hora_dia_p,0),
				dt_mes_06 = dt_ini_prev_p
		where	nr_sequencia = nr_sequencia_w;
		end;
	elsif (ie_mes_p = 7) then
		begin
		update	w_estimativa_proj_com
		set		vl_mes_07 = coalesce(coalesce(vl_mes_07,0)+qt_hora_dia_p,0),
				dt_mes_07 = dt_ini_prev_p
		where	nr_sequencia = nr_sequencia_w;
		end;
	elsif (ie_mes_p = 8) then
		begin
		update	w_estimativa_proj_com
		set		vl_mes_08 = coalesce(coalesce(vl_mes_08,0)+qt_hora_dia_p,0),
				dt_mes_08 = dt_ini_prev_p
		where	nr_sequencia = nr_sequencia_w;
		end;
	elsif (ie_mes_p = 9) then
		begin
		update	w_estimativa_proj_com
		set		vl_mes_09 = coalesce(coalesce(vl_mes_09,0)+qt_hora_dia_p,0),
				dt_mes_09 = dt_ini_prev_p
		where	nr_sequencia = nr_sequencia_w;
		end;
	elsif (ie_mes_p = 10) then
		begin
		update	w_estimativa_proj_com
		set		vl_mes_10 = coalesce(coalesce(vl_mes_10,0)+qt_hora_dia_p,0),
				dt_mes_10 = dt_ini_prev_p
		where	nr_sequencia = nr_sequencia_w;
		end;
	elsif (ie_mes_p = 11) then
		begin
		update	w_estimativa_proj_com
		set		vl_mes_11 = coalesce(coalesce(vl_mes_11,0)+qt_hora_dia_p,0),
				dt_mes_11 = dt_ini_prev_p
		where	nr_sequencia = nr_sequencia_w;
		end;
	elsif (ie_mes_p = 12) then
		begin
		update	w_estimativa_proj_com
		set		vl_mes_12 = coalesce(coalesce(vl_mes_12,0)+qt_hora_dia_p,0),
				dt_mes_12 = dt_ini_prev_p
		where	nr_sequencia = nr_sequencia_w;
		end;
	end if;
	end;
elsif (ie_opcao_p = 'D') then
	delete	from w_estimativa_proj_com;
elsif (ie_opcao_p = 'R') then
	begin
	update	w_estimativa_proj_com
	set	dt_mes_01 = PKG_DATE_UTILS.ADD_MONTH(dt_ini_prev_p,1,0),
		dt_mes_02 = PKG_DATE_UTILS.ADD_MONTH(dt_ini_prev_p,2,0),
		dt_mes_03 = PKG_DATE_UTILS.ADD_MONTH(dt_ini_prev_p,3,0),
		dt_mes_04 = PKG_DATE_UTILS.ADD_MONTH(dt_ini_prev_p,4,0),
		dt_mes_05 = PKG_DATE_UTILS.ADD_MONTH(dt_ini_prev_p,5,0),
		dt_mes_06 = PKG_DATE_UTILS.ADD_MONTH(dt_ini_prev_p,6,0),
		dt_mes_07 = PKG_DATE_UTILS.ADD_MONTH(dt_ini_prev_p,7,0),
		dt_mes_08 = PKG_DATE_UTILS.ADD_MONTH(dt_ini_prev_p,8,0),
		dt_mes_09 = PKG_DATE_UTILS.ADD_MONTH(dt_ini_prev_p,9,0),
		dt_mes_10 = PKG_DATE_UTILS.ADD_MONTH(dt_ini_prev_p,10,0),
		dt_mes_11 = PKG_DATE_UTILS.ADD_MONTH(dt_ini_prev_p,11,0),
		dt_mes_12 = PKG_DATE_UTILS.ADD_MONTH(dt_ini_prev_p,12,0);
	end;
elsif (ie_opcao_p = 'G') then
	begin
	if (ie_mes_p = 1) then
		begin
		update	w_estimativa_proj_com
		set		vl_mes_01 = coalesce(coalesce(vl_mes_01,0)+qt_hora_dia_p,0)
		where	nr_seq_cliente = nr_seq_cliente_p;
		end;
	elsif (ie_mes_p = 2) then
		begin
		update	w_estimativa_proj_com
		set		vl_mes_02 = coalesce(coalesce(vl_mes_02,0)+qt_hora_dia_p,0)
		where	nr_seq_cliente = nr_seq_cliente_p;
		end;
	elsif (ie_mes_p = 3) then
		begin
		update	w_estimativa_proj_com
		set		vl_mes_03 = coalesce(coalesce(vl_mes_03,0)+qt_hora_dia_p,0)
		where	nr_seq_cliente = nr_seq_cliente_p;
		end;
	elsif (ie_mes_p = 4) then
		begin
		update	w_estimativa_proj_com
		set		vl_mes_04 = coalesce(coalesce(vl_mes_04,0)+qt_hora_dia_p,0)
		where	nr_seq_cliente = nr_seq_cliente_p;
		end;
	elsif (ie_mes_p = 5) then
		begin
		update	w_estimativa_proj_com
		set		vl_mes_05 = coalesce(coalesce(vl_mes_05,0)+qt_hora_dia_p,0)
		where	nr_seq_cliente = nr_seq_cliente_p;
		end;
	elsif (ie_mes_p = 6) then
		begin
		update	w_estimativa_proj_com
		set		vl_mes_06 = coalesce(coalesce(vl_mes_06,0)+qt_hora_dia_p,0)
		where	nr_seq_cliente = nr_seq_cliente_p;
		end;
	elsif (ie_mes_p = 7) then
		begin
		update	w_estimativa_proj_com
		set		vl_mes_07 = coalesce(coalesce(vl_mes_07,0)+qt_hora_dia_p,0)
		where	nr_seq_cliente = nr_seq_cliente_p;
		end;
	elsif (ie_mes_p = 8) then
		begin
		update	w_estimativa_proj_com
		set		vl_mes_08 = coalesce(coalesce(vl_mes_08,0)+qt_hora_dia_p,0)
		where	nr_seq_cliente = nr_seq_cliente_p;
		end;
	elsif (ie_mes_p = 9) then
		begin
		update	w_estimativa_proj_com
		set		vl_mes_09 = coalesce(coalesce(vl_mes_09,0)+qt_hora_dia_p,0)
		where	nr_seq_cliente = nr_seq_cliente_p;
		end;
	elsif (ie_mes_p = 10) then
		begin
		update	w_estimativa_proj_com
		set		vl_mes_10 = coalesce(coalesce(vl_mes_10,0)+qt_hora_dia_p,0)
		where	nr_seq_cliente = nr_seq_cliente_p;
		end;
	elsif (ie_mes_p = 11) then
		begin
		update	w_estimativa_proj_com
		set	vl_mes_11 = coalesce(coalesce(vl_mes_11,0)+qt_hora_dia_p,0)
		where	nr_seq_cliente = nr_seq_cliente_p;
		end;
	elsif (ie_mes_p = 12) then
		begin
		update	w_estimativa_proj_com
		set	vl_mes_12 = coalesce(coalesce(vl_mes_12,0)+qt_hora_dia_p,0)
		where	nr_seq_cliente = nr_seq_cliente_p;
		end;
	end if;
	end;
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_w_estimativa_proj_com ( nr_seq_cliente_p bigint default 0, cd_consultor_p text default 'N', dt_ini_prev_p timestamp default null, ie_opcao_p text DEFAULT NULL, ie_mes_p bigint default 0, qt_hora_dia_p bigint default 0, nr_seq_mod_p bigint default 0, nm_usuario_p text DEFAULT NULL) FROM PUBLIC;

