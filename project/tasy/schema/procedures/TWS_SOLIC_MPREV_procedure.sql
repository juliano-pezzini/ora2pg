-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE tws_solic_mprev ( nr_seq_segurado_p pls_segurado.nr_sequencia%type, ds_observacao_p mprev_demanda_espont.ds_observacao%type, nr_ddd_contato_p mprev_demanda_espont.nr_ddd_contato%type, nr_telefone_contato_p mprev_demanda_espont.nr_telefone_contato%type, ds_programas_p text, ds_campanhas_p text, ds_patologias_p text, nm_usuario_p text, ds_msg_retorno_p INOUT text, ie_abortar_confirm_p INOUT text) AS $body$
DECLARE


/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade:
Gerar, consitir e confirmar a solicitacao de participacao na medicina preventiva.
-------------------------------------------------------------------------------------------------------------------

Locais de chamada direta: 
[  ]  Objetos do dicionario [ ] Tasy (Delphi/Java) [  ] Portal [  ]  Relatorios [ x] Outros: TWS
 ------------------------------------------------------------------------------------------------------------------

Pontos de atencao:
ie_abortar_confirm:
A - Abortar
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
 

nr_seq_demanda_w		mprev_demanda_espont.nr_sequencia%type;
nr_seq_captacao_w		mprev_captacao.nr_sequencia%type;
cd_pessoa_fisica_w		pessoa_fisica.cd_pessoa_fisica%type;
ie_patologia_fator_risco_w	mprev_captacao_diagnostico.ie_patologia_fator_risco%type;
ds_sequencia_w			varchar(50);
ds_temp_w			varchar(2);
ds_msg_retorno_w		varchar(2000)	:= null;
ie_abortar_confirm_w		varchar(1)	:= null;

c01 CURSOR FOR
	SELECT	nr_sequencia
	from	mprev_demanda_espont 
	where	nm_usuario	= nm_usuario_p 
	and	nr_seq_segurado = nr_seq_segurado_p
	and	coalesce(dt_confirmacao::text, '') = '' 	
	and	ie_origem = 'P';

BEGIN

select	cd_pessoa_fisica
into STRICT	cd_pessoa_fisica_w
from 	pls_segurado
where	nr_sequencia = nr_seq_segurado_p;

if (cd_pessoa_fisica_w IS NOT NULL AND cd_pessoa_fisica_w::text <> '') then
	for c01_w in c01 loop
		begin
		delete 	FROM mprev_captacao_diagnostico
		where	nr_seq_captacao in (	SELECT	nr_sequencia
						from	mprev_captacao
						where	nr_seq_demanda_espont = c01_w.nr_sequencia);

		delete 	FROM mprev_captacao_destino
		where	nr_seq_captacao in (	SELECT	nr_sequencia
						from	mprev_captacao
						where	nr_seq_demanda_espont = c01_w.nr_sequencia);

		delete	FROM mprev_captacao
		where	nr_seq_demanda_espont = c01_w.nr_sequencia;

		delete  FROM mprev_demanda_espont
		where	nr_sequencia = c01_w.nr_sequencia;
		end;
	end loop;
	
	insert into 	mprev_demanda_espont(	nr_sequencia, dt_atualizacao, nm_usuario,
						dt_atualizacao_nrec, nm_usuario_nrec, nr_seq_segurado,
						cd_pessoa_fisica, dt_solicitacao, nr_ddd_contato,
						nr_telefone_contato, ds_observacao, ie_origem)
				values ( 	nextval('mprev_demanda_espont_seq'), clock_timestamp(), nm_usuario_p,
						clock_timestamp(), nm_usuario_p, nr_seq_segurado_p,
						cd_pessoa_fisica_w, clock_timestamp(), nr_ddd_contato_p,
						nr_telefone_contato_p, ds_observacao_p, 'P') returning nr_sequencia into nr_seq_demanda_w;

	nr_seq_captacao_w := mprev_gerar_captacao_demanda(nr_seq_demanda_w, nm_usuario_p, nr_seq_captacao_w, 'N');

	if (nr_seq_captacao_w IS NOT NULL AND nr_seq_captacao_w::text <> '') then
		if (ds_programas_p IS NOT NULL AND ds_programas_p::text <> '') then
			-- Programas
			for i in 1..length(ds_programas_p) loop
				begin
				ds_temp_w := substr(ds_programas_p, i, 1);
				if (ds_temp_w = ';') then
					insert	into	mprev_captacao_destino( nr_sequencia, dt_atualizacao, nm_usuario,
										dt_atualizacao_nrec, nm_usuario_nrec, nr_seq_captacao,
										nr_seq_programa)
									values (nextval('mprev_captacao_destino_seq'), clock_timestamp(), nm_usuario_p,
										clock_timestamp(), nm_usuario_p, nr_seq_captacao_w,
										(ds_sequencia_w)::numeric );
				
					ds_sequencia_w := '';
				else
					ds_sequencia_w := ds_sequencia_w ||ds_temp_w;
				end if;
				end;
			end loop;
		end if;

		if (ds_campanhas_p IS NOT NULL AND ds_campanhas_p::text <> '') then
			-- Campanhas
			ds_sequencia_w := '';
			
			for i in 1..length(ds_campanhas_p) loop
				begin
				ds_temp_w := substr(ds_campanhas_p, i, 1);
				if (ds_temp_w = ';') then
					insert	into	mprev_captacao_destino( nr_sequencia, dt_atualizacao, nm_usuario,
										dt_atualizacao_nrec, nm_usuario_nrec, nr_seq_captacao,
										nr_seq_campanha)
									values (nextval('mprev_captacao_destino_seq'), clock_timestamp(), nm_usuario_p,
										clock_timestamp(), nm_usuario_p, nr_seq_captacao_w,
										(ds_sequencia_w)::numeric );
										
					ds_sequencia_w := '';					
				else
					ds_sequencia_w := ds_sequencia_w ||ds_temp_w;
				end if;
				end;
			end loop;
		end if;

		if (ds_patologias_p IS NOT NULL AND ds_patologias_p::text <> '') then
			-- Fator de risco
			ds_sequencia_w := '';
			
			for i in 1..length(ds_patologias_p) loop
				begin
				ds_temp_w := substr( ds_patologias_p , i, 1);
				if (ds_temp_w = ';') then		
					select 	CASE WHEN ie_utilizacao='FR' THEN  'F'  ELSE 'P' END
					into STRICT	ie_patologia_fator_risco_w
					from	diagnostico_interno
					where	nr_sequencia	= (ds_sequencia_w)::numeric;
				
					insert	into	mprev_captacao_diagnostico( nr_sequencia, dt_atualizacao, nm_usuario,
										    dt_atualizacao_nrec, nm_usuario_nrec, nr_seq_captacao,
										    ie_patologia_fator_risco, nr_seq_diagnostico_int)
									    values ( nextval('mprev_captacao_diagnostico_seq'), clock_timestamp(), nm_usuario_p,
										    clock_timestamp(), nm_usuario_p, nr_seq_captacao_w,
										    ie_patologia_fator_risco_w, (ds_sequencia_w)::numeric );
					ds_sequencia_w := '';
					
				else
					ds_sequencia_w := ds_sequencia_w ||ds_temp_w;
				end if;
				end;
			end loop;
		end if;
		
		SELECT * FROM mprev_consistir_captacao(	nr_seq_demanda_w, null, nm_usuario_p, ds_msg_retorno_w, ie_abortar_confirm_w) INTO STRICT ds_msg_retorno_w, ie_abortar_confirm_w;
						
		ds_msg_retorno_p	:= ds_msg_retorno_w;
		ie_abortar_confirm_p	:= ie_abortar_confirm_w;
		
		if (ie_abortar_confirm_w = 'A') then
			rollback;			
		else
			--rotina ja faz commit;
			CALL mprev_confirmar_demanda_espont(nr_seq_demanda_w, nm_usuario_p);
		end if;
	end if;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE tws_solic_mprev ( nr_seq_segurado_p pls_segurado.nr_sequencia%type, ds_observacao_p mprev_demanda_espont.ds_observacao%type, nr_ddd_contato_p mprev_demanda_espont.nr_ddd_contato%type, nr_telefone_contato_p mprev_demanda_espont.nr_telefone_contato%type, ds_programas_p text, ds_campanhas_p text, ds_patologias_p text, nm_usuario_p text, ds_msg_retorno_p INOUT text, ie_abortar_confirm_p INOUT text) FROM PUBLIC;
