-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE oft_insere_consulta_lente ( nr_seq_consulta_p bigint, nr_seq_consulta_form_p bigint, vListaConsultaLente strRecTypeFormOft) AS $body$
DECLARE


nr_sequencia_w				oft_consulta_lente.nr_sequencia%type;
dt_exame_w					oft_consulta_lente.dt_registro%type;
ds_observacao_w			oft_consulta_lente.ds_observacao%type;
qt_grau_esferico_w		oft_consulta_lente.qt_grau_esferico%type;
qt_eixo_w					oft_consulta_lente.qt_eixo%type;
qt_grau_cilindrico_w		oft_consulta_lente.qt_grau_cilindrico%type;
qt_adicao_w					oft_consulta_lente.qt_adicao%type;
nr_seq_lente_w				oft_consulta_lente.nr_seq_lente%type;
qt_grau_longe_w			oft_consulta_lente.qt_grau_longe%type;
ie_lado_w					oft_consulta_lente.ie_lado%type;
qt_grau_w					oft_consulta_lente.qt_grau%type;
cd_profissional_w			oft_consulta_lente.cd_profissional%type;
nm_usuario_w				usuario.nm_usuario%type := wheb_usuario_pck.get_nm_usuario;
ie_registrado_w			varchar(1) := 'N';
ds_erro_w					varchar(4000);

BEGIN
begin

if (coalesce(nr_seq_consulta_p,0) > 0) and (vListaConsultaLente.count > 0) then
	for i in 1..vListaConsultaLente.count loop
		begin
		if (vListaConsultaLente[i](.ds_valor IS NOT NULL AND .ds_valor::text <> '')) or (vListaConsultaLente[i](.nr_valor IS NOT NULL AND .nr_valor::text <> '')) then
			case upper(vListaConsultaLente[i].nm_campo)
				when 'CD_PROFISSIONAL' then
					cd_profissional_w						:= vListaConsultaLente[i].ds_valor;
				when 'DT_REGISTRO' then
					dt_exame_w 								:= pkg_date_utils.get_DateTime(vListaConsultaLente[i].ds_valor);
				when 'DS_OBSERVACAO' then
					ds_observacao_w						:= vListaConsultaLente[i].ds_valor;
					ie_registrado_w						:= 'S';
				when 'QT_GRAU_ESFERICO' then
					qt_grau_esferico_w					:= vListaConsultaLente[i].nr_valor;
					ie_registrado_w						:= 'S';
				when 'QT_EIXO' then
					qt_eixo_w								:= vListaConsultaLente[i].nr_valor;
					ie_registrado_w						:= 'S';
				when 'QT_GRAU_CILINDRICO' then
					qt_grau_cilindrico_w					:= vListaConsultaLente[i].nr_valor;
					ie_registrado_w						:= 'S';
				when 'QT_ADICAO' then
					qt_adicao_w								:= vListaConsultaLente[i].nr_valor;
					ie_registrado_w						:= 'S';
				when 'NR_SEQ_LENTE' then
					nr_seq_lente_w							:= vListaConsultaLente[i].nr_valor;
					ie_registrado_w						:= 'S';
				when 'QT_GRAU_LONGE' then
					qt_grau_longe_w						:= vListaConsultaLente[i].nr_valor;
					ie_registrado_w						:= 'S';
				when 'IE_LADO' then
					ie_lado_w								:= vListaConsultaLente[i].ds_valor;
				when 'QT_GRAU' then
					qt_grau_w								:= vListaConsultaLente[i].nr_valor;
					ie_registrado_w						:= 'S';
				else
					null;
			end case;
		end if;
	end;
	end loop;


	select	max(nr_sequencia)
	into STRICT		nr_sequencia_w
	from		oft_consulta_lente
	where		nr_seq_consulta_form = nr_seq_consulta_form_p
	and		nr_seq_consulta		= nr_seq_consulta_p
	and		coalesce(dt_liberacao::text, '') = ''
	and		nm_usuario				= nm_usuario_w;

	if (nr_sequencia_w IS NOT NULL AND nr_sequencia_w::text <> '') then
		update	oft_consulta_lente
		set		dt_atualizacao		=	clock_timestamp(),
					nm_usuario			=	nm_usuario_w,
					cd_profissional	= coalesce(cd_profissional_w,cd_profissional),
					dt_registro			=	coalesce(dt_exame_w,dt_registro),
					ds_observacao		=	ds_observacao_w,
					qt_grau_esferico	=	qt_grau_esferico_w,
					qt_eixo				=	qt_eixo_w,
					qt_grau_cilindrico=	qt_grau_cilindrico_w,
					qt_adicao			=	qt_adicao_w,
					nr_seq_lente		=	nr_seq_lente_w,
					qt_grau_longe		=	qt_grau_longe_w,
					ie_lado				=	ie_lado_w,
					qt_grau				=	qt_grau_w
		where		nr_sequencia		=	nr_sequencia_w;
		CALL wheb_usuario_pck.set_ie_commit('S');
	else
		if (ie_registrado_w = 'S') then
			CALL wheb_usuario_pck.set_ie_commit('S');
			select	nextval('oft_consulta_lente_seq')
			into STRICT		nr_sequencia_w
			;

			insert	into oft_consulta_lente(	nr_sequencia,
														dt_atualizacao,
														nm_usuario,
														dt_atualizacao_nrec,
														nm_usuario_nrec,
														cd_profissional,
														dt_registro,
														nr_seq_consulta,
														ie_situacao,
														ds_observacao,
														qt_grau_esferico,
														qt_eixo,
														qt_grau_cilindrico,
														qt_adicao,
														nr_seq_lente,
														qt_grau_longe,
														ie_lado,
														qt_grau,
														nr_seq_consulta_form)
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
														qt_grau_esferico_w,
														qt_eixo_w,
														qt_grau_cilindrico_w,
														qt_adicao_w,
														nr_seq_lente_w,
														qt_grau_longe_w,
														ie_lado_w,
														qt_grau_w,
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
-- REVOKE ALL ON PROCEDURE oft_insere_consulta_lente ( nr_seq_consulta_p bigint, nr_seq_consulta_form_p bigint, vListaConsultaLente strRecTypeFormOft) FROM PUBLIC;

