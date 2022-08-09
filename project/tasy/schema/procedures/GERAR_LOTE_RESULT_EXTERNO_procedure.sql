-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_lote_result_externo ( nr_seq_lote_p bigint, dt_inicial_p timestamp, dt_final_p timestamp, cd_setor_p bigint, cd_equipamento_p bigint, ie_opcao_p bigint, cd_interface_p bigint, nm_usuario_p text) AS $body$
DECLARE


nr_prescricao_w				bigint;
nr_seq_prescr_w				integer;
cd_pessoa_fisica_w			varchar(10);
nr_seq_grupo_w				bigint;
nr_seq_metodo_w				bigint;
dt_digitacao_w				timestamp;
dt_aprovacao_w				timestamp;
cd_medico_resp_w			varchar(10);
ds_observacao_w				varchar(4000);
cd_exame_w				varchar(20);
ds_resultado_w				varchar(4000);
qt_resultado_w				double precision;
pr_resultado_w				double precision;
nr_seq_unidade_w			bigint;
ds_referencia_w				varchar(4000);
qt_minima_ref_w				double precision;
qt_maxima_ref_w				double precision;
nr_seq_exame_w				bigint;
cd_setor_coleta_w			integer;
nr_seq_item_w				bigint;
dt_geracao_w				timestamp;
nr_controle_w				varchar(15);
ie_permite_req_exame_w			varchar(10);


c01 CURSOR FOR
SELECT		a.nr_prescricao,
		b.nr_sequencia,
		a.cd_pessoa_fisica,
		e.nr_seq_grupo,
		c.nr_seq_metodo,
		c.dt_digitacao,
		c.dt_aprovacao,
		c.cd_medico_resp,
		c.ds_observacao,
		e.cd_exame,
		c.ds_resultado,
		c.qt_resultado,
		c.pr_resultado,
		c.nr_seq_unid_med,
		c.ds_referencia,
		c.qt_minima,
		c.qt_maxima,
		e.nr_seq_exame,
		b.cd_setor_coleta,
		a.nr_controle
from		exame_laboratorio e,
		prescr_medica a,
		prescr_procedimento b,
		exame_lab_resultado d,
		exame_lab_result_item c
where		a.nr_prescricao = b.nr_prescricao
and		a.nr_prescricao = d.nr_prescricao
and		b.nr_sequencia 	= c.nr_seq_prescr
and		c.nr_seq_exame	= e.nr_seq_exame
and		c.nr_seq_resultado = d.nr_seq_resultado
and		b.cd_setor_coleta = cd_setor_p
and		c.dt_aprovacao between dt_inicial_p and dt_final_p
and		(Obter_Equipamento_Exame(e.nr_seq_exame,cd_equipamento_p,'CI') IS NOT NULL AND (Obter_Equipamento_Exame(e.nr_seq_exame,cd_equipamento_p,'CI'))::text <> '')
and		b.ie_status_atend >= 35
and		((ie_permite_req_exame_w = 'S' AND a.nr_controle IS NOT NULL AND a.nr_controle::text <> '') or (ie_permite_req_exame_w = 'N'));

C02 CURSOR FOR
SELECT	 a.nr_prescricao,
	 b.nr_sequencia,
	 a.cd_pessoa_fisica,
	 e.nr_seq_grupo,
	 e.cd_exame,
	 e.nr_seq_exame,
	 b.cd_setor_coleta,
	 a.nr_controle
from	 exame_laboratorio e,
	 prescr_procedimento b,
	 prescr_medica a
where	 a.nr_prescricao = b.nr_prescricao
and	 e.nr_seq_exame = b.nr_seq_exame
and (b.cd_setor_coleta = cd_setor_p or coalesce(cd_setor_p::text, '') = '')
and  (((obter_equipamento_exame(e.nr_seq_exame,cd_equipamento_p,'CI') IS NOT NULL AND (obter_equipamento_exame(e.nr_seq_exame,cd_equipamento_p,'CI'))::text <> '')) or (coalesce(cd_equipamento_p::text, '') = ''))
and	((ie_permite_req_exame_w = 'S' AND a.nr_controle IS NOT NULL AND a.nr_controle::text <> '') or (ie_permite_req_exame_w = 'N'))
and	 a.dt_prescricao between dt_inicial_p and fim_dia(dt_final_p);


BEGIN

--função 8051
select	coalesce(Obter_Valor_Param_Usuario(8051,1, obter_perfil_ativo, nm_usuario_p, 0),'N')
into STRICT	ie_permite_req_exame_w
;

if (ie_opcao_p = 1) then /*Gerar Lote*/
	if (cd_interface_p <> 2190) then
		open C01;
		loop
		fetch C01 into
			nr_prescricao_w,
			nr_seq_prescr_w,
			cd_pessoa_fisica_w,
			nr_seq_grupo_w,
			nr_seq_metodo_w,
			dt_digitacao_w,
			dt_aprovacao_w,
			cd_medico_resp_w,
			ds_observacao_w,
			cd_exame_w,
			ds_resultado_w,
			qt_resultado_w,
			pr_resultado_w,
			nr_seq_unidade_w,
			ds_referencia_w,
			qt_minima_ref_w,
			qt_maxima_ref_w,
			nr_seq_exame_w,
			cd_setor_coleta_w,
			nr_controle_w;

		EXIT WHEN NOT FOUND; /* apply on C01 */

			select 	nextval('lab_lote_result_item_seq')
			into STRICT	nr_seq_item_w
			;

			insert into lab_lote_result_item(
				nr_sequencia,
				dt_atualizacao,
				nm_usuario,
				dt_atualizacao_nrec,
				nm_usuario_nrec,
				nr_seq_lote,
				nr_prescricao,
				nr_seq_prescr,
				cd_pessoa_fisica,
				ds_amostra,
				nr_seq_grupo,
				nr_seq_metodo,
				dt_resultado,
				dt_aprovacao,
				cd_medico_resp,
				ds_observacao,
				cd_exame,
				ds_resultado,
				qt_resultado,
				pr_resultado,
				nr_seq_unidade,
				ds_referencia,
				qt_minimo_ref,
				qt_maximo_ref,
				nr_seq_exame,
				cd_setor_coleta,
				nr_requisicao_ext)
			values (
				nr_seq_item_w,
				clock_timestamp(),
				nm_usuario_p,
				clock_timestamp(),
				nm_usuario_p,
				nr_seq_lote_p,
				nr_prescricao_w,
				nr_seq_prescr_w,
				cd_pessoa_fisica_w,
				'',
				nr_seq_grupo_w,
				nr_seq_metodo_w,
				dt_digitacao_w,
				dt_aprovacao_w,
				cd_medico_resp_w,
				ds_observacao_w,
				cd_exame_w,
				ds_resultado_w,
				qt_resultado_w,
				pr_resultado_w,
				nr_seq_unidade_w,
				ds_referencia_w,
				qt_minima_ref_w,
				qt_maxima_ref_w,
				nr_seq_exame_w,
				cd_setor_coleta_w,
				nr_controle_w);

			update	lab_lote_result_externo
			set		dt_geracao = clock_timestamp()
			where	nr_sequencia = nr_seq_lote_p;

		end loop;
		close C01;
	elsif (cd_interface_p = 2190) then
		open C02;
		loop
		fetch C02 into
			nr_prescricao_w,
			nr_seq_prescr_w,
			cd_pessoa_fisica_w,
			nr_seq_grupo_w,
			cd_exame_w,
			nr_seq_exame_w,
			cd_setor_coleta_w,
			nr_controle_w;
		EXIT WHEN NOT FOUND; /* apply on C02 */
			begin

			select 	nextval('lab_lote_result_item_seq')
			into STRICT	nr_seq_item_w
			;

			insert into lab_lote_result_item(
				nr_sequencia,
				dt_atualizacao,
				nm_usuario,
				dt_atualizacao_nrec,
				nm_usuario_nrec,
				nr_seq_lote,
				nr_prescricao,
				nr_seq_prescr,
				cd_pessoa_fisica,
				ds_amostra,
				nr_seq_grupo,
				cd_exame,
				nr_seq_exame,
				cd_setor_coleta,
				nr_requisicao_ext)
			values (
				nr_seq_item_w,
				clock_timestamp(),
				nm_usuario_p,
				clock_timestamp(),
				nm_usuario_p,
				nr_seq_lote_p,
				nr_prescricao_w,
				nr_seq_prescr_w,
				cd_pessoa_fisica_w,
				'',
				nr_seq_grupo_w,
				cd_exame_w,
				nr_seq_exame_w,
				cd_setor_coleta_w,
				nr_controle_w);
			end;
		end loop;
		close C02;

		update	lab_lote_result_externo
		set	dt_geracao = clock_timestamp()
		where	nr_sequencia = nr_seq_lote_p;
	end if;

elsif (ie_opcao_p = 2) then /*desfazer lote*/
	select	dt_geracao
	into STRICT	dt_geracao_w
	from	lab_lote_result_externo
	where	nr_sequencia = nr_seq_lote_p;

	if (dt_geracao_w IS NOT NULL AND dt_geracao_w::text <> '') 	then

		delete 	FROM lab_lote_result_item
		where	nr_seq_lote = nr_seq_lote_p;

		update	lab_lote_result_externo
		set		dt_geracao  = NULL
		where	nr_sequencia = nr_seq_lote_p;
	end if;
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_lote_result_externo ( nr_seq_lote_p bigint, dt_inicial_p timestamp, dt_final_p timestamp, cd_setor_p bigint, cd_equipamento_p bigint, ie_opcao_p bigint, cd_interface_p bigint, nm_usuario_p text) FROM PUBLIC;
