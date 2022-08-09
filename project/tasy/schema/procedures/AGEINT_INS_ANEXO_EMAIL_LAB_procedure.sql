-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE ageint_ins_anexo_email_lab ( nr_seq_agenda_int_p bigint, nm_usuario_p text, cd_estab_envio_p bigint default null) AS $body$
DECLARE


/*ROTINA UTILIZADA APENAS PARA INSERCAO DE ANEXOS PARA EXAMES LABORATORIAIS*/
											
nr_sequencia_w			bigint;
nr_sequencia_ww			bigint;
nr_seq_regra_anexo_w	bigint;
nr_seq_ageint_item_w	bigint;
ie_tipo_agendamento_w	varchar(15);
ie_tipo_agend_regra_w	varchar(1);
ds_arquivo_anexo_w		varchar(255);											
qt_arq_anexados_w		bigint;
qt_exames_lancados_w	bigint;
ds_erro_w				varchar(255);
ie_tipo_age_w			varchar(15);
nr_proc_int_w			bigint;
cd_convenio_w			integer;

--Itens do agendamentos
C01 CURSOR FOR
	SELECT	nr_sequencia,
			nr_seq_proc_interno,
			ageint_obter_cd_conv_item_lab(nr_sequencia)
	from	ageint_exame_lab
	where	nr_seq_ageint = nr_seq_agenda_int_p
	order by	1;

--Regra de envio de anexos(Agenda Integrada > "Cadastros" > "Agenda Integrada" > "Regra de envio de anexos")
C02 CURSOR FOR
	SELECT	nr_sequencia
	from	ageint_regra_anexo
	where	ie_tipo_agendamento = 'L'
	and		ie_situacao = 'A'
	and (nr_seq_proc_interno = nr_proc_int_w
	or 		coalesce(nr_seq_proc_interno::text, '') = '')
	and (cd_convenio = cd_convenio_w
	or 		coalesce(cd_convenio::text, '') = '')
	and (cd_estabelecimento = cd_estab_envio_p
	or      coalesce(cd_estabelecimento::text, '') = '')
	order by	coalesce(ie_tipo_agendamento,'A');
	

BEGIN

if (nr_seq_agenda_int_p IS NOT NULL AND nr_seq_agenda_int_p::text <> '') then
	begin
	open C01;
	loop
	fetch C01 into	
		nr_seq_ageint_item_w,
		nr_proc_int_w,
		cd_convenio_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		begin
		--Tipo de agendamento
		select	'E'
		into STRICT	ie_tipo_agendamento_w
		;
		
		if (ie_tipo_agendamento_w = 'E')then
			
			open C02;
			loop
			fetch C02 into	
				nr_sequencia_w;
			EXIT WHEN NOT FOUND; /* apply on C02 */
				begin
				
				select	coalesce(ie_tipo_agendamento,'A')
				into STRICT	ie_tipo_agend_regra_w
				from	ageint_regra_anexo
				where	nr_sequencia = nr_sequencia_w;				
				
				if (nr_sequencia_w IS NOT NULL AND nr_sequencia_w::text <> '')then
					--Arquivo a ser enviado anexo
					select	substr(ds_arquivo,1,255)
					into STRICT	ds_arquivo_anexo_w
					from	ageint_regra_anexo
					where	nr_sequencia = nr_sequencia_w;					
					
					if (ds_arquivo_anexo_w IS NOT NULL AND ds_arquivo_anexo_w::text <> '')then
						select	count(*)
						into STRICT	qt_arq_anexados_w
						from	ageint_arq_anexo_email
						where	ds_arquivo 			= ds_arquivo_anexo_w
						and		nr_seq_agenda_int 	= nr_seq_agenda_int_p;						
						
						if (qt_arq_anexados_w = 0)then
							select	nextval('ageint_arq_anexo_email_seq')
							into STRICT	nr_sequencia_ww
							;							
							
							/*if	(nr_sequencia_ww is not null) and
								(ie_tipo_agend_regra_w <> 'L')then
								--Insere anexo cadastrado na regra(Exames nao-laboratoriais)

								insert into ageint_arq_anexo_email(	
																ds_arquivo,
																dt_atualizacao,
																dt_atualizacao_nrec,
																nm_usuario,
																nr_seq_agenda_int,
																nr_sequencia
																)
								values							(
																ds_arquivo_anexo_w,
																sysdate,
																sysdate,
																nm_usuario_p,
																nr_seq_agenda_int_p,
																nr_sequencia_ww
																);
								commit;
							els*/
							if (nr_sequencia_ww IS NOT NULL AND nr_sequencia_ww::text <> '') and (ie_tipo_agend_regra_w = 'L')then
								--Insere anexo cadastrado na regra(Exames laboratoriais)
								select	count(*)
								into STRICT	qt_exames_lancados_w
								from	ageint_exame_lab
								where	nr_seq_ageint = nr_seq_agenda_int_p;
								
								if (qt_exames_lancados_w > 0)then
									
									insert into ageint_arq_anexo_email(	
																ds_arquivo,
																dt_atualizacao,
																dt_atualizacao_nrec,
																nm_usuario,
																nr_seq_agenda_int,
																nr_sequencia
																)
									values (
																ds_arquivo_anexo_w,
																clock_timestamp(),
																clock_timestamp(),
																nm_usuario_p,
																nr_seq_agenda_int_p,
																nr_sequencia_ww
																);
									commit;
								
								end if;
								
							
							end if;							
						
						end if;
					
					end if;
				
				end if;				
				
				end;
			end loop;
			close C02;
		
		end if;
		
		exception
		when others then
			ds_erro_w	:= substr(sqlerrm,1,255);
		end;
	end loop;
	close C01;
	
	end;	
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ageint_ins_anexo_email_lab ( nr_seq_agenda_int_p bigint, nm_usuario_p text, cd_estab_envio_p bigint default null) FROM PUBLIC;
