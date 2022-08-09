-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_ordem_da_prescricao ( dt_referencia_p timestamp, cd_estabelecimento_p bigint, ie_gerar_ordem_pac_chegada_p text, nm_usuario_p text, nr_prescricao_p text, ds_erro_p INOUT text) AS $body$
DECLARE


nr_sequencia_log_w		bigint;
ie_liberado_w			varchar(1);
cd_perfil_w                 integer;
ie_consiste_ordem_w		varchar(1);
nr_seq_atendimento_w		bigint;
nr_seq_paciente_w		bigint;
cd_medico_resp_w		varchar(10);
nr_prescricao_w			bigint;
cd_estabelecimento_w		smallint;
nm_paciente_w			varchar(60);
ie_gerar_prescr_w		varchar(1);
ie_restringir_ordem_w		varchar(1);
ie_exibe_apto_w			varchar(1);
ie_consiste_dias_anter_w	varchar(1);
ie_possui_dia_ant_w			varchar(1);
ds_retorno_ww		varchar(255);
dt_chagada_w				timestamp;
ds_entrada_w		varchar(4000);
ds_log_w		varchar(4000);
ds_erro_log_w		varchar(4000);
ds_erro_w			varchar(2000);

C01 CURSOR FOR
	SELECT	nr_seq_atendimento,
		nr_seq_paciente,
		nr_prescricao,
		dt_chegada
	from	paciente_atendimento
	where	trunc(coalesce(dt_real,dt_prevista)) = trunc(dt_referencia_p)
	AND 	((cd_estabelecimento = cd_estabelecimento_p) OR (ie_restringir_ordem_w = 'N'))
	and	((dt_chegada IS NOT NULL AND dt_chegada::text <> '') or (ie_gerar_ordem_pac_chegada_p = 'N'))
	and 	((dt_apto IS NOT NULL AND dt_apto::text <> '') or (coalesce(ie_exibe_apto_w,'N') = 'N'))
	and	coalesce(dt_cancelamento::text, '') = ''
	and	nr_prescricao = nr_prescricao_p;


BEGIN

ds_erro_p := '';
ds_entrada_w := '1';

select nextval('log_gera_ordem_seq')
into STRICT	nr_sequencia_log_w
;

insert into log_gera_ordem(
	nr_sequencia,
	nm_usuario,
	dt_inicio)
values (nr_sequencia_log_w,
	wheb_usuario_pck.get_nm_usuario,
	clock_timestamp());

commit;

ie_liberado_w := 'N';
cd_perfil_w :=  obter_perfil_ativo;

ie_consiste_ordem_w := Obter_Param_Usuario(3130, 169, cd_perfil_w, nm_usuario_p, cd_estabelecimento_p, ie_consiste_ordem_w);
ie_gerar_prescr_w := Obter_Param_Usuario(3130, 55, cd_perfil_w, nm_usuario_p, cd_estabelecimento_p, ie_gerar_prescr_w);
ie_restringir_ordem_w := Obter_Param_Usuario(3130, 165, cd_perfil_w, nm_usuario_p, cd_estabelecimento_p, ie_restringir_ordem_w);
ie_exibe_apto_w := Obter_Param_Usuario(3130, 204, cd_perfil_w, nm_usuario_p, cd_estabelecimento_p, ie_exibe_apto_w);
ie_consiste_dias_anter_w := Obter_Param_Usuario(3130, 407, cd_perfil_w, nm_usuario_p, cd_estabelecimento_p, ie_consiste_dias_anter_w);

if (ie_consiste_ordem_w = 'S') then
	while(ie_liberado_w <> 'S')  loop
		begin
		select 	coalesce(max('N'),'S')
		into STRICT 	ie_liberado_w
		from 	log_gera_ordem
		where 	nr_sequencia < nr_sequencia_log_w
		and (dt_inicio +1/288) > clock_timestamp()
		and 	coalesce(dt_final::text, '') = '';
		end;
	end loop;
end if;

begin

    OPEN C01;
	LOOP
	FETCH C01 into
		nr_seq_atendimento_w,
		nr_seq_paciente_w,
		nr_prescricao_w,
		dt_chagada_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		begin
		ds_entrada_w := substr(ds_entrada_w || ',2',1,4000);
		select	cd_medico_resp,
			cd_estabelecimento,
			substr(obter_nome_pf(cd_pessoa_fisica),1,60)
		into STRICT	cd_medico_resp_w,
			cd_estabelecimento_w,
			nm_paciente_w
		from	paciente_setor
		where	nr_seq_paciente	= nr_seq_paciente_w;
		if (coalesce(cd_medico_resp_w::text, '') = '') then
			CALL wheb_mensagem_pck.Exibir_Mensagem_Abort(184696, 'NM_PACIENTE_W='||nm_paciente_w);
		end if;

		if (ie_consiste_dias_anter_w = 'S') then
			ds_entrada_w := substr(ds_entrada_w || ',3',1,4000);
			select 	coalesce(max('S'),'N')
			into STRICT	ie_possui_dia_ant_w
			from	paciente_atendimento a
			where	a.nr_seq_paciente	=	nr_seq_paciente_w
			and		nr_seq_atendimento < nr_seq_atendimento_w
			and		not exists (SELECT	1
								from	can_ordem_prod x
								where	x.nr_seq_atendimento = a.nr_seq_atendimento);

			if (ie_possui_dia_ant_w = 'S') then
				ds_erro_p := wheb_mensagem_pck.get_texto(228255);
				CALL wheb_mensagem_pck.Exibir_Mensagem_Abort(228255);
			end if;

		end if;


		if (coalesce(nr_prescricao_w::text, '') = '') and (ie_gerar_prescr_w = 'S') then
			ds_entrada_w := substr(ds_entrada_w || ',4',1,4000);
			ds_retorno_ww := Gerar_Prescricao_Paciente(nr_seq_atendimento_w, nm_usuario_p, cd_estabelecimento_w, null, null, 'N', ds_retorno_ww);
		end if;
		end;
	END LOOP;
	Close C01;

    ds_erro_p := GERAR_ORDEM_DA_PRESCRICAO_IMPL(dt_referencia_p, cd_estabelecimento_p, ie_gerar_ordem_pac_chegada_p, nm_usuario_p, nr_prescricao_p, nr_sequencia_log_w, ds_erro_p);

    update  log_gera_ordem
	set 	dt_final = clock_timestamp()
	where 	nr_sequencia = nr_sequencia_log_w;
	commit;

    ds_log_w := substr('1 : GERAR_ORDEM_DA_PRESCRICAO ds_entrada = '  || ds_entrada_w 	     || CHR(10) || CHR(13) ||
				'nr_seq_atendimento_w'              || nr_seq_atendimento_w          || CHR(10) || CHR(13) ||
				'nr_seq_paciente_w'                 || nr_seq_paciente_w             || CHR(10) || CHR(13) ||
				'cd_medico_resp_w'                  || cd_medico_resp_w              || CHR(10) || CHR(13) ||
				'nr_prescricao_w'                   || nr_prescricao_w               || CHR(10) || CHR(13) ||
				'cd_estabelecimento_w'              || cd_estabelecimento_w          || CHR(10) || CHR(13) ||
				'nm_paciente_w'                     || nm_paciente_w                 || CHR(10) || CHR(13) ||
				'ie_gerar_prescr_w'                 || ie_gerar_prescr_w             || CHR(10) || CHR(13) ||
				'ie_restringir_ordem_w'             || ie_restringir_ordem_w         || CHR(10) || CHR(13) ||
				'nr_sequencia_log_w'                || nr_sequencia_log_w            || CHR(10) || CHR(13) ||
                'ie_liberado_w'                     || ie_liberado_w                 || CHR(10) || CHR(13) ||
                'ie_consiste_ordem_w'               || ie_consiste_ordem_w           || CHR(10) || CHR(13) ||
				'ie_exibe_apto_w'                   || ie_exibe_apto_w               || CHR(10) || CHR(13) ||
				'ie_consiste_dias_anter_w'          || ie_consiste_dias_anter_w      || CHR(10) || CHR(13) ||
				'cd_perfil_w'                       || cd_perfil_w                   || CHR(10) || CHR(13) ||
				'ds_retorno_ww'                     || ds_retorno_ww                 || CHR(10) || CHR(13), 1,4000);

    CALL gerar_log_quimio(NULL,
            nr_prescricao_p,
            NULL,
            ds_log_w,
            'G',
            nm_usuario_p);

exception
when others then

    ds_erro_w := substr(SQLERRM(SQLSTATE),1,255);
	ds_erro_log_w := ds_erro_log_w || ' - ' || ds_erro_w;

    ds_log_w := substr(Wheb_mensagem_pck.get_texto(455586) || ' : GERAR_ORDEM_DA_PRESCRICAO ds_entrada = '  || ds_entrada_w 	     || CHR(10) || CHR(13) || /* ERRO!! */
				'nr_seq_atendimento_w'              || nr_seq_atendimento_w          || CHR(10) || CHR(13) ||
				'nr_seq_paciente_w'                 || nr_seq_paciente_w             || CHR(10) || CHR(13) ||
				'cd_medico_resp_w'                  || cd_medico_resp_w              || CHR(10) || CHR(13) ||
				'nr_prescricao_w'                   || nr_prescricao_w               || CHR(10) || CHR(13) ||
				'cd_estabelecimento_w'              || cd_estabelecimento_w          || CHR(10) || CHR(13) ||
				'nm_paciente_w'                     || nm_paciente_w                 || CHR(10) || CHR(13) ||
				'ie_gerar_prescr_w'                 || ie_gerar_prescr_w             || CHR(10) || CHR(13) ||
				'ie_restringir_ordem_w'             || ie_restringir_ordem_w         || CHR(10) || CHR(13) ||
				'nr_sequencia_log_w'                || nr_sequencia_log_w            || CHR(10) || CHR(13) ||
                'ie_liberado_w'                     || ie_liberado_w                 || CHR(10) || CHR(13) ||
                'ie_consiste_ordem_w'               || ie_consiste_ordem_w           || CHR(10) || CHR(13) ||
				'ie_exibe_apto_w'                   || ie_exibe_apto_w               || CHR(10) || CHR(13) ||
				'ie_consiste_dias_anter_w'          || ie_consiste_dias_anter_w      || CHR(10) || CHR(13) ||
				'cd_perfil_w'                       || cd_perfil_w                   || CHR(10) || CHR(13) ||
				'ds_retorno_ww'                     || ds_retorno_ww                 || CHR(10) || CHR(13) ||
				Wheb_mensagem_pck.get_texto(455587) || '=' ||ds_erro_log_w ,1,4000); /* ERRO */
    CALL gerar_log_quimio(NULL,
            nr_prescricao_p,
            NULL,
            ds_log_w,
            'G',
            nm_usuario_p);

    update  log_gera_ordem
	set 	dt_final = clock_timestamp()
	where 	nr_sequencia = nr_sequencia_log_w;
	commit;

end;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_ordem_da_prescricao ( dt_referencia_p timestamp, cd_estabelecimento_p bigint, ie_gerar_ordem_pac_chegada_p text, nm_usuario_p text, nr_prescricao_p text, ds_erro_p INOUT text) FROM PUBLIC;
