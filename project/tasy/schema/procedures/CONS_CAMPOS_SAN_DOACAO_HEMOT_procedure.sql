-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE cons_campos_san_doacao_hemot ( ds_campo_p text, nr_pasta_p bigint, nr_seq_doacao_p bigint, cd_pessoa_fisica_p text, nr_seq_reserva_p bigint, nr_seq_transfusao_p bigint, nr_seq_derivado_p bigint, dt_doacao_p timestamp, ie_tipo_coleta_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text, nr_seq_reserva_out_p INOUT bigint, ie_tipo_doador_p INOUT text, qt_coletada_p INOUT bigint, qt_amostra_p INOUT bigint, nr_seq_doacao_soro_p INOUT bigint, ie_impedido_p INOUT text, ds_mensagem_p INOUT text, ds_msg_ult_doacao_p INOUT text, ds_msg_doador_p INOUT text, ds_pergunta_p INOUT text, ds_perg_idade_p INOUT text, ds_perg_doador_inapto_p INOUT text) AS $body$
DECLARE


/*	nr_pasta_p
	0 - Doacao
	1 - Producao
	*/
ie_perm_inserir_tipo_doador_w		varchar(1);
ie_alt_vol_triagem_sel_hemo_w		varchar(1);
ie_bloq_doador_fora_regra_w		varchar(1);
ie_regra_doacao_apos_pac_w		varchar(1);
ie_consiste_doador_inapto_w		varchar(1);
nm_pessoa_fisica_w			varchar(80);
dt_nascimento_w				timestamp;
ie_sexo_w				varchar(1);
ie_san_doador_inapto_w			varchar(1);
dt_doacao_w				timestamp;
ie_possui_registro_w			varchar(1);
nr_seq_reserva_w			bigint;
ie_impedido_w				varchar(1);


BEGIN
ie_consiste_doador_inapto_w := obter_param_usuario(450, 431, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p, ie_consiste_doador_inapto_w);

if (ds_campo_p = 'CD_PESSOA_FISICA') then
	begin


	if (cd_pessoa_fisica_p IS NOT NULL AND cd_pessoa_fisica_p::text <> '') then
		begin
		select 	CASE WHEN count(*)=0 THEN 'N'  ELSE 'S' END  ie_impedido
		into STRICT	ie_impedido_w
		from 	san_doador_inapto a,
				pessoa_fisica b
		where	b.cd_pessoa_fisica = cd_pessoa_fisica_p
		and (a.cd_pessoa_fisica = b.cd_pessoa_fisica
		or	upper(a.nm_pessoa_fisica) = upper(b.nm_pessoa_fisica))
		and	a.dt_nascimento = b.dt_nascimento
		and	a.ie_sexo = b.ie_sexo
		and (coalesce(a.ie_definitivo,'D') = 'D'
		or (a.ie_definitivo = 'T' and coalesce(a.dt_limite_inaptidao,clock_timestamp()) > clock_timestamp()))
		and	coalesce(a.dt_inativacao::text, '') = ''
		order by 1;


		if (ie_consiste_doador_inapto_w = 'S') then					
			select	max(upper(elimina_acentuacao(substr(obter_nome_pf(cd_pessoa_fisica),1,100)))),
				max(dt_nascimento),
				max(ie_sexo)
			into STRICT	nm_pessoa_fisica_w,
					dt_nascimento_w,
					ie_sexo_w
			from	pessoa_fisica
			where	cd_pessoa_fisica = cd_pessoa_fisica_p;

			ie_impedido_p	:= san_obter_se_doador_impedido(cd_pessoa_fisica_p);

			select	CASE WHEN count(*)=0 THEN  'N'  ELSE 'S' END
			into STRICT	ie_san_doador_inapto_w
			from	san_doador_inapto
			where	upper(nm_pessoa_fisica) = nm_pessoa_fisica_w
			and	dt_nascimento	= dt_nascimento_w
			and	ie_sexo		= ie_sexo_w
			and	coalesce(dt_inativacao::text, '') = '';

				if (ie_san_doador_inapto_w = 'S') then
					ds_perg_doador_inapto_p	:= obter_texto_tasy(75642, wheb_usuario_pck.get_nr_seq_idioma);
				end if;
		elsif (ie_consiste_doador_inapto_w = 'B') and (ie_impedido_w = 'S') then
			
				if (ie_san_doador_inapto_w = 'S') then
					ds_perg_doador_inapto_p	:= obter_texto_tasy(210691, wheb_usuario_pck.get_nr_seq_idioma);
				end if;
		end if;

		select	max(dt_doacao)
		into STRICT	dt_doacao_w
		from	san_doacao
		where	cd_pessoa_fisica = cd_pessoa_fisica_p
		and	coalesce(nr_motivo_desistencia::text, '') = ''
		and ie_tipo_coleta <> 2;

		if (dt_doacao_w IS NOT NULL AND dt_doacao_w::text <> '') then
			ds_msg_ult_doacao_p	:= obter_texto_dic_objeto(75644, wheb_usuario_pck.get_nr_seq_idioma, 'QT_DIAS=' || trunc(clock_timestamp() - dt_doacao_w) || ';DT_ULT_DOACAO=' || to_char(dt_doacao_w, 'dd/mm/yyyy'));
		end if;

		ds_msg_doador_p := gerar_regra_doacao_san(
			nr_seq_doacao_p, nm_usuario_p, ie_tipo_coleta_p, cd_pessoa_fisica_p, ds_msg_doador_p, null, dt_doacao_p);

			
		/* Hemoterapia - Parametro [177] - Consistir regra de doacao apos informar o paciente
		     Hemoterapia - Parametro [176] - Permitir a doacao de doadores que nao se encaixem na regra de doacao */
		ie_bloq_doador_fora_regra_w := obter_param_usuario(450, 176, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p, ie_bloq_doador_fora_regra_w);
		ie_regra_doacao_apos_pac_w := obter_param_usuario(450, 177, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p, ie_regra_doacao_apos_pac_w);
		
		if (ie_regra_doacao_apos_pac_w = 'S') then
			if (ie_bloq_doador_fora_regra_w = 'Q') then
				ds_msg_doador_p	:= ds_msg_doador_p || obter_texto_tasy(75690, wheb_usuario_pck.get_nr_seq_idioma);
			end if;
		end if;

		/* Hemoterapia - Parametro [149] - Atualiza automaticamente o tipo de doador */

		ie_perm_inserir_tipo_doador_w := obter_param_usuario(450, 149, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p, ie_perm_inserir_tipo_doador_w);

		if (ie_perm_inserir_tipo_doador_w = 'S') then
			ie_tipo_doador_p	:= san_obter_tipo_doador_atual(cd_pessoa_fisica_p, dt_doacao_p);
		end if;

		end;
	end if;
	end;

elsif (ds_campo_p = 'NR_SEQ_RESERVA') then
	begin
	if (nr_seq_reserva_p IS NOT NULL AND nr_seq_reserva_p::text <> '') then
		begin
		select	CASE WHEN count(*)=0 THEN  'N'  ELSE 'S' END
		into STRICT	ie_possui_registro_w
		from	san_reserva
		where	nr_sequencia = nr_seq_reserva_p;

		if (ie_possui_registro_w = 'N') then
			ds_mensagem_p	:= obter_texto_tasy(75705, wheb_usuario_pck.get_nr_seq_idioma);
		end if;
		end;
	end if;
	end;

elsif (ds_campo_p = 'NR_SEQ_TRANSFUSAO') then
	begin
	if (nr_seq_transfusao_p IS NOT NULL AND nr_seq_transfusao_p::text <> '') then
		begin
		select	CASE WHEN count(*)=0 THEN  'N'  ELSE 'S' END
		into STRICT	ie_possui_registro_w
		from	san_transfusao
		where	nr_sequencia = nr_seq_transfusao_p;

		if (ie_possui_registro_w = 'N') then
			ds_mensagem_p	:= obter_texto_tasy(75706, wheb_usuario_pck.get_nr_seq_idioma);
		else
			begin
			select	coalesce(nr_seq_reserva, 0)
			into STRICT	nr_seq_reserva_w
			from	san_transfusao
			where	nr_sequencia = nr_seq_transfusao_p;

			if (nr_seq_reserva_w <> 0) and (coalesce(nr_seq_reserva_p::text, '') = '') then
				nr_seq_reserva_out_p	:= nr_seq_reserva_w;
			end if;
			end;
		end if;
		end;
	end if;
	end;

elsif (ds_campo_p = 'NR_SEQ_DERIVADO') then
	begin
	if (nr_pasta_p = 1) then
		begin
		/* Hemoterapia - Parametro [185] - Ao informar o hemocomponente na triagem alterar o volume coletado */

		ie_alt_vol_triagem_sel_hemo_w := obter_param_usuario(450, 185, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p, ie_alt_vol_triagem_sel_hemo_w);

		if (ie_alt_vol_triagem_sel_hemo_w = 'S') and (nr_seq_derivado_p IS NOT NULL AND nr_seq_derivado_p::text <> '') then
			begin
			select	qt_volume
			into STRICT	qt_coletada_p
			from	san_derivado
			where	nr_sequencia = nr_seq_derivado_p;
			end;
		end if;
		end;
	end if;
	end;

elsif (ds_campo_p = 'IE_TIPO_COLETA') then
	begin
	if (nr_pasta_p = 0) and (ie_tipo_coleta_p = 2) then
		begin
		nr_seq_doacao_soro_p	:= san_obter_doacao_sorologia(cd_pessoa_fisica_p, nr_seq_doacao_p);

		if (nr_seq_doacao_soro_p <> 0) then
			begin
			select	dt_doacao
			into STRICT	dt_doacao_w
			from	san_doacao
			where	nr_sequencia = nr_seq_doacao_soro_p;

			ds_pergunta_p	:= obter_texto_dic_objeto(75750, wheb_usuario_pck.get_nr_seq_idioma, 'NR_SEQ_DOACAO_SORO=' || nr_seq_doacao_soro_p || ';DT_DOACAO_SORO=' || to_char(dt_doacao_w, 'dd/mm/yyyy'));

			select	count(*) + 2
			into STRICT	qt_amostra_p
			from	san_doacao
			where	nr_seq_doacao_amostra = nr_seq_doacao_soro_p;
			end;
		else
			ds_pergunta_p	:= obter_texto_tasy(75757, wheb_usuario_pck.get_nr_seq_idioma);
		end if;
		end;
	end if;
	end;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE cons_campos_san_doacao_hemot ( ds_campo_p text, nr_pasta_p bigint, nr_seq_doacao_p bigint, cd_pessoa_fisica_p text, nr_seq_reserva_p bigint, nr_seq_transfusao_p bigint, nr_seq_derivado_p bigint, dt_doacao_p timestamp, ie_tipo_coleta_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text, nr_seq_reserva_out_p INOUT bigint, ie_tipo_doador_p INOUT text, qt_coletada_p INOUT bigint, qt_amostra_p INOUT bigint, nr_seq_doacao_soro_p INOUT bigint, ie_impedido_p INOUT text, ds_mensagem_p INOUT text, ds_msg_ult_doacao_p INOUT text, ds_msg_doador_p INOUT text, ds_pergunta_p INOUT text, ds_perg_idade_p INOUT text, ds_perg_doador_inapto_p INOUT text) FROM PUBLIC;
