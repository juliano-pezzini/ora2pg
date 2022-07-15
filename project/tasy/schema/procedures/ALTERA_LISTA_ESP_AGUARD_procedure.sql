-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE altera_lista_esp_aguard (nr_seq_agenda_p bigint, nm_usuario_p text, ie_reverte_p text default 'N') AS $body$
DECLARE


qt_registros_w					bigint;
cnpj_solicitante_origem_w  		agenda_integrada.cnpj_solicitante%type;
nr_seq_lista_espera_origem_w	agenda_integrada_item.nr_seq_lista_espera_origem%type;
nr_sequencia_agen_list_esp_w  	agenda_lista_espera.nr_sequencia%type;
ie_status_espera_w				agenda_lista_espera.ie_status_espera%type := 'A';
ie_falta_w						agenda_lista_espera.ie_falta%type := 'S';
nr_seq_situacao_atual_w			lista_espera_situacao_cont.nr_sequencia%type;
ie_forma_atualizacao_w			funcao_param_usuario.vl_parametro%type;
dt_atualizacao_w				regulacao_status.dt_atualizacao_nrec%type;
ie_status_w						varchar(5) := 'FA';
cd_expressao1_w					bigint := 1096710;
cd_expressao2_w					bigint := 1096594;


BEGIN

	select	count(*)
	into STRICT	qt_registros_w
	from	agenda_integrada_item
	where (nr_seq_agenda_cons = nr_seq_agenda_p and coalesce(nr_seq_agenda_exame::text, '') = '')
	or (nr_seq_agenda_exame = nr_seq_agenda_p and coalesce(nr_seq_agenda_cons::text, '') = '');

	if (qt_registros_w > 0) then
		begin

			select	max(ai.cnpj_solicitante),
					max(aii.nr_seq_lista_espera_origem)
			into STRICT	cnpj_solicitante_origem_w,
					nr_seq_lista_espera_origem_w
			from	agenda_integrada_item	aii,
					agenda_integrada		ai
			where	((aii.nr_seq_agenda_cons = nr_seq_agenda_p and coalesce(aii.nr_seq_agenda_exame::text, '') = '')
			or (aii.nr_seq_agenda_exame = nr_seq_agenda_p and coalesce(aii.nr_seq_agenda_cons::text, '') = ''))
			and		ai.nr_sequencia			=	aii.nr_seq_agenda_int;

			if (cnpj_solicitante_origem_w IS NOT NULL AND cnpj_solicitante_origem_w::text <> '') and (nr_seq_lista_espera_origem_w IS NOT NULL AND nr_seq_lista_espera_origem_w::text <> '') then

				select  max(nr_sequencia)
				into STRICT	nr_sequencia_agen_list_esp_w
				from    agenda_lista_espera
				where   cnpj_origem = cnpj_solicitante_origem_w
				and     nr_seq_lista_espera_origem = nr_seq_lista_espera_origem_w;	

			else

				select	max(ai.nr_seq_lista_espera)
				into STRICT	nr_seq_lista_espera_origem_w
				from	agenda_integrada_item	aii,
						agenda_integrada		ai
				where	((aii.nr_seq_agenda_cons = nr_seq_agenda_p and coalesce(aii.nr_seq_agenda_exame::text, '') = '')
				or (aii.nr_seq_agenda_exame = nr_seq_agenda_p and coalesce(aii.nr_seq_agenda_cons::text, '') = ''))
				and		ai.nr_sequencia			=	aii.nr_seq_agenda_int;

				if (nr_seq_lista_espera_origem_w IS NOT NULL AND nr_seq_lista_espera_origem_w::text <> '') then

					select  max(nr_sequencia)
					into STRICT	nr_sequencia_agen_list_esp_w
					from    agenda_lista_espera
					where   nr_sequencia = nr_seq_lista_espera_origem_w
					and		coalesce(ie_integracao,'N') = 'N';

				end if;
			end if;

			if (nr_sequencia_agen_list_esp_w IS NOT NULL AND nr_sequencia_agen_list_esp_w::text <> '') then
				begin

					if (ie_reverte_p = 'S') then
						ie_status_espera_w	:= 'E';
						ie_falta_w			:= 'N';
						ie_status_w			:= 'AG';
						cd_expressao1_w		:= 1098955;
						cd_expressao2_w		:= 1098955;
					end if;

					update  agenda_lista_espera
					set     ie_status_espera = ie_status_espera_w,
							ie_falta = ie_falta_w
					where   nr_sequencia = nr_sequencia_agen_list_esp_w;

					select	min(nr_sequencia)
					into STRICT	nr_seq_situacao_atual_w
					from	lista_espera_situacao_cont
					where	ie_situacao = 'A'
					and		ie_tipo_contato = 'PF';

					if (nr_seq_situacao_atual_w IS NOT NULL AND nr_seq_situacao_atual_w::text <> '') or (ie_reverte_p = 'S') then
						begin

							insert into ag_lista_espera_contato(
								nr_sequencia,
								dt_atualizacao,
								dt_atualizacao_nrec,
								nm_usuario,
								nm_usuario_nrec,
								nr_seq_lista_espera,
								dt_contato,
								ie_origem,
								nm_pessoa_contato,
								nr_seq_situacao_atual,
								ds_observacao,
								dt_liberacao,
								nm_usuario_liberacao,
								ie_contato_realizado
							) values (
								nextval('ag_lista_espera_contato_seq'),
								clock_timestamp(),
								clock_timestamp(),
								nm_usuario_p,
								nm_usuario_p,
								nr_sequencia_agen_list_esp_w,
								clock_timestamp(),
								'A',
								obter_pessoa_fisica_usuario(nm_usuario_p, null),
								CASE WHEN ie_reverte_p='S' THEN  ''  ELSE nr_seq_situacao_atual_w END ,
								obter_expressao_dic_objeto(cd_expressao2_w),
								clock_timestamp(),
								nm_usuario_p,
								'N'
							);

						end;
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
-- REVOKE ALL ON PROCEDURE altera_lista_esp_aguard (nr_seq_agenda_p bigint, nm_usuario_p text, ie_reverte_p text default 'N') FROM PUBLIC;

