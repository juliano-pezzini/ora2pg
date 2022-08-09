-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_registro_problema ( nr_sequencia_p bigint, ie_main_enc_probl_p text) AS $body$
DECLARE


nr_atendimento_w		bigint;
cd_pessoa_fisica_w		varchar(10);
ie_tipo_diagnostico_w	smallint;
cd_doenca_w				varchar(10);
cd_ciap_w				varchar(10);
cd_medico_w				varchar(10);
nm_usuario_w			varchar(15);
ds_problema_w			varchar(4000);

nr_seq_mentor_w			bigint;
nr_regras_atendidas_w 	varchar(2000);
ie_gera_prot_assist		boolean := False;

nr_seq_registro_w 		lista_problema_pac_item.nr_seq_registro%type;
nr_seq_historico_w		lista_problema_pac.nr_seq_historico%type;
nr_seq_tipo_hist_w		lista_problema_pac.nr_seq_tipo_hist%type;
nr_seq_apresen_esp_w	lista_problema_pac.nr_seq_apresen_esp%type;
nm_tabela_w				tipo_historico_saude.nm_tabela%type;
ds_erro_w				varchar(4000);


BEGIN


if (coalesce(nr_sequencia_p,0) > 0 ) then

	nm_usuario_w := wheb_usuario_pck.get_nm_usuario;

	Select 	max(nr_atendimento),
			max(cd_pessoa_fisica),
			max(cd_doenca),
			max(cd_ciap),
        	max(coalesce(ie_tipo_diagnostico,2)),
			max(ds_problema),
			max(nr_seq_historico),
			max(nr_seq_tipo_hist),
			max(nr_seq_apresen_esp)
	into STRICT	nr_atendimento_w,
			cd_pessoa_fisica_w,
			cd_doenca_w,
			cd_ciap_w,
			ie_tipo_diagnostico_w,
			ds_problema_w,
			nr_seq_historico_w,
			nr_seq_tipo_hist_w,
			nr_seq_apresen_esp_w
	from	lista_problema_pac
	where	nr_sequencia = nr_sequencia_p;

	select  Obter_Pf_Usuario(nm_usuario_w,'C')
	into STRICT	cd_medico_w
	;

	if (cd_doenca_w IS NOT NULL AND cd_doenca_w::text <> '') then
		if (cd_medico_w IS NOT NULL AND cd_medico_w::text <> '') then
			CALL Gerar_diagnostico_problema(nr_sequencia_p,nr_atendimento_w,cd_doenca_w,cd_medico_w,nm_usuario_w,ie_tipo_diagnostico_w,'S',clock_timestamp(),ie_main_enc_probl_p);

			select	coalesce(max(nr_seq_registro),0)
			into STRICT	nr_seq_registro_w
			from	lista_problema_pac_item a
			where	a.nr_seq_problema	= nr_sequencia_p
			and		ie_tipo_registro	= 'DM';

			if (nr_seq_registro_w <> 0) then
				SELECT * FROM GQA_LIBERACAO_DIAGNOSTICO(nr_seq_registro_w, nm_usuario_w, nr_seq_mentor_w, nr_regras_atendidas_w) INTO STRICT nr_seq_mentor_w, nr_regras_atendidas_w;
				ie_gera_prot_assist := True;
			end if;
		end if;
	end if;

	if (cd_ciap_w IS NOT NULL AND cd_ciap_w::text <> '') then
		CALL gerar_ciap_problema(nr_sequencia_p, nr_atendimento_w, cd_ciap_w, cd_medico_w, nm_usuario_w, ds_problema_w);

		select	coalesce(max(nr_seq_registro),0)
		into STRICT	nr_seq_registro_w
		from	lista_problema_pac_item a
		where	a.nr_seq_problema	= nr_sequencia_p
		and		ie_tipo_registro	= 'CP';

		if (nr_seq_registro_w <> 0) then
			SELECT * FROM GQA_Liberacao_ciap(nr_seq_registro_w, nm_usuario_w, nr_seq_mentor_w, nr_regras_atendidas_w) INTO STRICT nr_seq_mentor_w, nr_regras_atendidas_w;
			ie_gera_prot_assist := True;
		end if;
	end if;

	if (nr_seq_historico_w IS NOT NULL AND nr_seq_historico_w::text <> '' AND nr_seq_tipo_hist_w IS NOT NULL AND nr_seq_tipo_hist_w::text <> '') then
		select	nm_tabela
		into STRICT	nm_tabela_w
		from	tipo_historico_saude
		where	nr_sequencia = nr_seq_tipo_hist_w;

		SELECT * FROM gravar_historico_saude(nm_tabela_w, nr_seq_historico_w, cd_pessoa_fisica_w, 'S', nr_atendimento_w, null, nm_usuario_w, nr_seq_registro_w, ds_erro_w) INTO STRICT nr_seq_registro_w, ds_erro_w;

		if (coalesce(ds_erro_w::text, '') = '') then
			insert into lista_problema_pac_item(	nr_sequencia,
												dt_atualizacao,
												dt_atualizacao_nrec,
												nm_usuario,
												nm_usuario_nrec,
												nr_seq_problema,
												nr_seq_registro,
												ie_tipo_registro,
												nm_tabela,
												ie_tipo_problema,
												nr_seq_tipo_hist )
									values (		nextval('lista_problema_pac_item_seq'),
												clock_timestamp(),
												clock_timestamp(),
												nm_usuario_w,
												nm_usuario_w,
												nr_sequencia_p,
												nr_seq_registro_w,
												'HS',
												nm_tabela_w,
												nr_seq_historico_w,
												nr_seq_tipo_hist_w);
		end if;
	end if;

	CALL gerar_fatos_problema(nr_sequencia_p,nm_usuario_w);
	CALL gerar_especialidade_problema(nr_sequencia_p,cd_pessoa_fisica_w,nm_usuario_w,nr_seq_apresen_esp_w,'S');

	if ie_gera_prot_assist then
		CALL gera_protocolo_assistencial(nr_atendimento_w, nm_usuario_w);
	end if;

end if;


end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_registro_problema ( nr_sequencia_p bigint, ie_main_enc_probl_p text) FROM PUBLIC;
