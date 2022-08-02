-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE san_grava_inf_importacao_hemo (nr_serie_hemomix_p bigint, nr_operador_p text, nr_doador_p text, nr_doacao_p text, nr_lote_bolsa_p text, vl_solicitado_ml_p bigint, vl_coletado_p bigint, hr_inicio_coleta_p text, hr_fim_coleta_p text, hr_tempo_coleta_p text, dt_coleta_p timestamp, vl_fluxo_ml_p bigint, nr_intercorrencia_p text, nm_usuario_p text) AS $body$
DECLARE


nr_seq_doacao_ww	bigint := null;
nr_seq_doacao_w		bigint;
nr_seq_reacao_w		bigint;
nr_seq_reacao_ext_w	bigint;
nr_serie_hemomix_w	bigint;
ie_realiza_insert_w	varchar(1);
ie_realiza_update_w	varchar(1);
cd_pessoa_coleta_w	varchar(10);
ds_conduta_w		varchar(255);
nr_seq_derivado_w	bigint;
ie_tipo_bolsa_w		varchar(5);
nr_seq_conservante_w	bigint;
nr_seq_antic_w		bigint;
qt_peso_bolsa_padrao_w	double precision;
ie_regra_derivado_w	varchar(1);
ds_valor_param_331_w	varchar(255);

C01 CURSOR FOR
	SELECT	obter_somente_numero(substr(nr_intercorrencia_p, 2,2)) nr_reacao,
		x.nr_sequencia
	from	san_doacao x
	where	x.nr_sequencia = nr_seq_doacao_ww
	and	obter_somente_numero(substr(nr_intercorrencia_p, 2,2)) <> 0
	
union all

	SELECT	obter_somente_numero(substr(nr_intercorrencia_p, 5,4)) nr_reacao,
		x.nr_sequencia
	from	san_doacao x
	where	x.nr_sequencia = nr_seq_doacao_ww
	and	obter_somente_numero(substr(nr_intercorrencia_p, 5,4)) <> 0
	
union all

	select	obter_somente_numero(substr(nr_intercorrencia_p, 10,4)) nr_reacao,
		x.nr_sequencia
	from	san_doacao x
	where	x.nr_sequencia = nr_seq_doacao_ww
	and	obter_somente_numero(substr(nr_intercorrencia_p, 10,4)) <> 0
	order by	1;



BEGIN
if (nr_doacao_p IS NOT NULL AND nr_doacao_p::text <> '') then

	ds_conduta_w := obter_valor_param_usuario(450,342,obter_perfil_ativo,wheb_usuario_pck.get_nm_usuario,wheb_usuario_pck.get_cd_estabelecimento);
	ie_regra_derivado_w := obter_valor_param_usuario(450,418,obter_perfil_ativo,wheb_usuario_pck.get_nm_usuario,wheb_usuario_pck.get_cd_estabelecimento);
	ds_valor_param_331_w :=  obter_valor_param_usuario(450, 331, wheb_usuario_pck.get_cd_perfil, wheb_usuario_pck.get_nm_usuario, wheb_usuario_pck.get_cd_estabelecimento);

	--Extrai a Seq. da doação do código de barras
	if (ds_valor_param_331_w = 'B') then
		select	max(nr_sequencia)
		into STRICT	nr_seq_doacao_ww
		from	san_doacao
		where	obter_isbt_doador(nr_sequencia, NULL,'I') = nr_doacao_p;
	else
		select	max(nr_sequencia)
		into STRICT	nr_seq_doacao_ww
		from	san_doacao
		where	cd_barras_integracao = nr_doacao_p;
	end if;

	select  CASE WHEN count(*)=0 THEN 'N'  ELSE 'S' END
	into STRICT	ie_realiza_update_w
	from	san_doacao x
	where	x.nr_sequencia = nr_seq_doacao_ww;

	select	max(x.cd_pessoa_fisica)
	into STRICT	cd_pessoa_coleta_w
	from	usuario x
	where	x.cd_barras  = nr_operador_p;

	select	max(x.nr_sequencia)
	into STRICT	nr_serie_hemomix_w
	from	san_local_doacao x
	where	x.cd_codigo_externo  = nr_serie_hemomix_p;

	if (vl_coletado_p > 0) then
		select	nr_seq_derivado_padrao,
			nr_seq_antic,
			ie_tipo_bolsa
		into STRICT	nr_seq_derivado_w,
			nr_seq_antic_w,
			ie_tipo_bolsa_w
		from	san_doacao
		where	nr_sequencia = nr_seq_doacao_ww;

		if (ie_regra_derivado_w = 'S') then
			select	max(nr_sequencia)
			into STRICT	nr_seq_conservante_w
			from	san_conservante
			where	nr_seq_anticoagulante = nr_seq_antic_w;

			qt_peso_bolsa_padrao_w := san_calc_peso_hemo(nr_seq_derivado_w,
									vl_coletado_p,
									null,
									nr_seq_conservante_w,
									null	,
									ie_tipo_bolsa_w);
		else
			qt_peso_bolsa_padrao_w := san_calc_peso_padrao(nr_seq_derivado_w,vl_coletado_p);
		end if;
	end if;

	if (ie_realiza_update_w = 'S') then
	begin
		update	san_doacao x
		set	x.nr_seq_local		= nr_serie_hemomix_w,
			x.cd_pessoa_coleta	= cd_pessoa_coleta_w,
			x.cd_pessoa_inicio_coleta = cd_pessoa_coleta_w,
			x.nr_lote_bolsa		= trim(both replace(nr_lote_bolsa_p,'&)',null)),
			x.qt_volume_estimado	= vl_solicitado_ml_p,
			x.qt_coletada		= vl_coletado_p,
			x.qt_volume_real	= vl_coletado_p,
			x.qt_peso_bolsa_padrao	= qt_peso_bolsa_padrao_w,
			x.dt_inicio_coleta_real	= to_date(to_char(dt_coleta_p,'dd/mm/yyyy')||hr_inicio_coleta_p, 'dd/mm/yyyy hh24:mi:ss'),
			x.dt_fim_coleta_real	= to_date(to_char(dt_coleta_p,'dd/mm/yyyy')||hr_fim_coleta_p, 'dd/mm/yyyy hh24:mi:ss'),
			x.qt_min_coleta		= round(	(to_date(to_char(dt_coleta_p,'dd/mm/yyyy')||hr_fim_coleta_p, 'dd/mm/yyyy hh24:mi:ss') -
								to_date(to_char(dt_coleta_p,'dd/mm/yyyy')||hr_inicio_coleta_p, 'dd/mm/yyyy hh24:mi:ss')) * 1440),
			x.dt_coleta		= to_date(to_char(dt_coleta_p,'dd/mm/yyyy')),
			x.vl_fluxo		= vl_fluxo_ml_p
		where	1 = 1
		and	x.nr_sequencia		= nr_seq_doacao_ww;

	exception
		when others then
		CALL gravar_log_tasy(-98766, 1||' - '||obter_texto_dic_objeto(102753, 0, 'CD='||nr_seq_doacao_ww||' -> '||sqlerrm), nm_usuario_p);
	end;

	elsif (ie_realiza_update_w = 'N') then
		CALL gravar_log_tasy(-98766, 2||' - '||obter_texto_dic_objeto(102168, 0, 'CD='||nr_seq_doacao_ww), nm_usuario_p);
	end if;



	--Grava as informações das reações da doação.
	begin
	open C01;
	loop
	fetch C01 into
		nr_seq_reacao_w,
		nr_seq_doacao_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		begin
			select	CASE WHEN count(*)=0 THEN 'N'  ELSE 'S' END
			into STRICT	ie_realiza_insert_w
			from	san_tipo_reacao x
			where	x.cd_reacao_externa = nr_seq_reacao_w;

			select	max(nr_sequencia)
			into STRICT	nr_seq_reacao_ext_w
			from	san_tipo_reacao x
			where	x.cd_reacao_externa = nr_seq_reacao_w;


		if (ie_realiza_insert_w = 'S') then
		begin
			insert into san_doacao_reacao(
				nr_sequencia,
				nr_seq_doacao,
				nr_seq_reacao,
				ds_conduta,
				cd_pf_realizou,
				dt_atualizacao,
				nm_usuario,
				dt_atualizacao_nrec,
				nm_usuario_nrec
			) values (
				nextval('san_doacao_reacao_seq'),
				nr_seq_doacao_w,
				nr_seq_reacao_ext_w,
				ds_conduta_w,
				cd_pessoa_coleta_w,
				clock_timestamp(),
				nm_usuario_p,
				clock_timestamp(),
				nm_usuario_p);
		exception
			when others then
			CALL gravar_log_tasy(-98766, wheb_mensagem_pck.get_texto(803066,
										'IE_REALIZA_INSERT='||ie_realiza_insert_w||
										';DS_CONDUTA='||ds_conduta_w||
										';NR_SEQ_REACAO='||nr_seq_reacao_w||
										';NR_SEQ_DOACAO='||nr_seq_doacao_w||
										';NR_INTERCORRENCIA='||nr_intercorrencia_p||sqlerrm), nm_usuario_p);
		end;

		elsif (ie_realiza_insert_w = 'N') then
			CALL gravar_log_tasy(-98766, '4 - '||obter_texto_dic_objeto(102164, 0, 'CD='||nr_seq_reacao_w), nm_usuario_p);
		end if;
	end;
	end loop;
	close C01;

	exception
		when others then
		CALL gravar_log_tasy(-98766, wheb_mensagem_pck.get_texto(803067,
								'NR_DOACAO='||nr_doacao_p||
								';NR_INTERCORRENCIA='||nr_intercorrencia_p), nm_usuario_p);
	end;

else
	CALL gravar_log_tasy(-98766, '6 - '||obter_texto_dic_objeto(102164, 0, 'CD='||nr_seq_doacao_ww), nm_usuario_p);
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE san_grava_inf_importacao_hemo (nr_serie_hemomix_p bigint, nr_operador_p text, nr_doador_p text, nr_doacao_p text, nr_lote_bolsa_p text, vl_solicitado_ml_p bigint, vl_coletado_p bigint, hr_inicio_coleta_p text, hr_fim_coleta_p text, hr_tempo_coleta_p text, dt_coleta_p timestamp, vl_fluxo_ml_p bigint, nr_intercorrencia_p text, nm_usuario_p text) FROM PUBLIC;

