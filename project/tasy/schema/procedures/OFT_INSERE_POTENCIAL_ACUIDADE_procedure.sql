-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE oft_insere_potencial_acuidade ( nr_seq_consulta_p bigint, nr_seq_consulta_form_p bigint, vListaPotencialAcuidade strRecTypeFormOft) AS $body$
DECLARE


nr_sequencia_w			oft_potencial_acuidade.nr_sequencia%type;
dt_exame_w				oft_potencial_acuidade.dt_registro%type;
ds_observacao_w		oft_potencial_acuidade.ds_observacao%type;
vl_potencial_od_w		oft_potencial_acuidade.vl_potencial_od%type;
vl_potencial_oe_w		oft_potencial_acuidade.vl_potencial_oe%type;
cd_profissional_w		oft_potencial_acuidade.cd_profissional%type;
nm_usuario_w			usuario.nm_usuario%type := wheb_usuario_pck.get_nm_usuario;
ie_registrado_w		varchar(1) := 'N';
ds_erro_w				varchar(4000);

BEGIN
begin

if (coalesce(nr_seq_consulta_p,0) > 0) and (vListaPotencialAcuidade.count > 0) then
	for i in 1..vListaPotencialAcuidade.count loop
		begin
		if (vListaPotencialAcuidade[i](.ds_valor IS NOT NULL AND .ds_valor::text <> '')) or (vListaPotencialAcuidade[i](.nr_valor IS NOT NULL AND .nr_valor::text <> '')) then
			case upper(vListaPotencialAcuidade[i].nm_campo)
				when 'CD_PROFISSIONAL' then
					cd_profissional_w							:= vListaPotencialAcuidade[i].ds_valor;
				when 'DT_REGISTRO' then
					dt_exame_w 									:= pkg_date_utils.get_DateTime(vListaPotencialAcuidade[i].ds_valor);
				when 'DS_OBSERVACAO' then
					ds_observacao_w							:= vListaPotencialAcuidade[i].ds_valor;
					ie_registrado_w							:= 'S';
				when 'VL_POTENCIAL_OD' then
					vl_potencial_od_w							:= vListaPotencialAcuidade[i].nr_valor;
					ie_registrado_w							:= 'S';
				when 'VL_POTENCIAL_OE' then
					vl_potencial_oe_w							:= vListaPotencialAcuidade[i].nr_valor;
					ie_registrado_w							:= 'S';
				else
					null;
			end case;
		end if;
	end;
	end loop;

	select	max(nr_sequencia)
	into STRICT		nr_sequencia_w
	from		oft_potencial_acuidade
	where		nr_seq_consulta_form = nr_seq_consulta_form_p
	and		nr_seq_consulta		= nr_seq_consulta_p
	and		coalesce(dt_liberacao::text, '') = ''
	and		nm_usuario				= nm_usuario_w;

	if (nr_sequencia_w IS NOT NULL AND nr_sequencia_w::text <> '') then
		update	oft_potencial_acuidade
		set		dt_atualizacao		=	clock_timestamp(),
					nm_usuario			=	nm_usuario_w,
					cd_profissional	= coalesce(cd_profissional_w,cd_profissional),
					dt_registro			=	coalesce(dt_exame_w,dt_registro),
					ds_observacao		=	ds_observacao_w,
					vl_potencial_od	=	vl_potencial_od_w,
					vl_potencial_oe	=	vl_potencial_oe_w
		where		nr_sequencia		=	nr_sequencia_w;
		CALL wheb_usuario_pck.set_ie_commit('S');
	else
		if (ie_registrado_w = 'S') then
			CALL wheb_usuario_pck.set_ie_commit('S');
			select	nextval('oft_potencial_acuidade_seq')
			into STRICT		nr_sequencia_w
			;

			insert	into oft_potencial_acuidade(	nr_sequencia,
														dt_atualizacao,
														nm_usuario,
														dt_atualizacao_nrec,
														nm_usuario_nrec,
														cd_profissional,
														dt_registro,
														nr_seq_consulta,
														ie_situacao,
														ds_observacao,
														vl_potencial_od,
														vl_potencial_oe,
														nr_seq_consulta_form
														)
			values (	nr_sequencia_w,
														clock_timestamp(),
														nm_usuario_w,
														clock_timestamp(),
														nm_usuario_w,
														coalesce(cd_profissional_w,obter_pf_usuario(nm_usuario_w,'C')),
														coalesce(dt_exame_w,clock_timestamp()),
														nr_seq_consulta_p,
														'A',
														ds_observacao_w,
														vl_potencial_od_w,
														vl_potencial_oe_w,
														nr_seq_consulta_form_p);
		end if;
	end if;
end if;

exception
when others then
	ds_erro_w	:= substr(sqlerrm,1,4000);
	update	OFT_CONSULTA_FORMULARIO
	set		ds_stack			=	substr(dbms_utility.format_call_stack||ds_erro_w,1,4000)
	where		nr_sequencia	= 	nr_seq_consulta_form_p;
end;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE oft_insere_potencial_acuidade ( nr_seq_consulta_p bigint, nr_seq_consulta_form_p bigint, vListaPotencialAcuidade strRecTypeFormOft) FROM PUBLIC;

