-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE hc_envio_ci_clepa ( ds_lista_checklist_p text, nr_seq_paciente_hc_p bigint default 0, nm_usuario_p text  DEFAULT NULL) AS $body$
DECLARE

 
/*valores checklist*/
 
lista_checklist_w		dbms_sql.varchar2_table;
ie_profissional_checklist_w	varchar(5);
ds_checklist_w			varchar(255);
nr_seq_checklist_w		bigint;
profissao_processada_w		varchar(1);

/*Regra envio alerta Home Care ? CLEPA*/
 
ds_titulo_w			varchar(255);
ds_texto_comunic_w		varchar(4000);

nm_usuario_w			varchar(50);

varProfiProcessadas 		varchar(400);
nr_seq_comunic_w		bigint;
nr_seq_classif_w		bigint;

 
c01 CURSOR FOR 
SELECT	ds_titulo, 
	hc_traduz_macros(nr_seq_paciente_hc_p, ds_texto_comunic) 
from	HC_REGRA_ENVIO_CLEPA 
where	ie_profissional = ie_profissional_checklist_w 
and	ie_situacao = 'A';

c02 CURSOR FOR 
SELECT	b.nm_usuario 
FROM	hc_profissional a , 
	usuario b					 
WHERE 	a.cd_pessoa_fisica	= b.cd_pessoa_fisica 
AND 	a.ie_profissional	= ie_profissional_checklist_w;

BEGIN 
 
if (ds_lista_checklist_p IS NOT NULL AND ds_lista_checklist_p::text <> '') then 
 
	ds_checklist_w		:= ds_lista_checklist_p;
	lista_checklist_w	:= obter_lista_string(ds_checklist_w, ',');
	 
	for	i in lista_checklist_w.first..lista_checklist_w.last loop 
		nr_seq_checklist_w	:= lista_checklist_w(i);
		 
		SELECT	max(a.ie_profissional) 
		INTO STRICT  ie_profissional_checklist_w 
		FROM	checklist_processo a, 
			checklist_processo_item b 
		WHERE	a.nr_sequencia = b.nr_seq_checklist 
		AND	a.nr_Sequencia = nr_seq_checklist_w;
		 
		if (ie_profissional_checklist_w IS NOT NULL AND ie_profissional_checklist_w::text <> '') then 
			 
				select 	Obter_Se_Contido_char(ie_profissional_checklist_w, varProfiProcessadas) 
				into STRICT	profissao_processada_w 
				;		
 
			if (profissao_processada_w = 'N') then 
			 
				varProfiProcessadas := ie_profissional_checklist_w || ',' || varProfiProcessadas;					
				 
				begin 
		 
				open c01;
				loop 
				fetch c01 into 
					ds_titulo_w, 
					ds_texto_comunic_w;
				EXIT WHEN NOT FOUND; /* apply on c01 */
					 
					begin								 					 
						select	obter_classif_comunic('F') 
						into STRICT	nr_seq_classif_w 
						;
																 
						open c02;
						loop 
						fetch c02 into 
							nm_usuario_w;
						EXIT WHEN NOT FOUND; /* apply on c02 */
						 
						select	nextval('comunic_interna_seq') 
						into STRICT	nr_seq_comunic_w 
						;
						 
						insert into comunic_interna( 
								dt_comunicado, 
								ds_titulo, 
								ds_comunicado, 
								nm_usuario, 
								dt_atualizacao, 
								ie_geral, 
								nm_usuario_destino, 
								nr_sequencia, 
								ie_gerencial, 
								nr_seq_classif, 
								dt_liberacao) 
							values (	clock_timestamp(), 
								ds_titulo_w, 
								ds_texto_comunic_w, 
								nm_usuario_p, 
								clock_timestamp(), 
								'N', 
								nm_usuario_w, 
								nr_seq_comunic_w, 
								'N', 
								nr_seq_classif_w, 
								clock_timestamp());
						end loop;
						close c02;	
					end;					
				end loop;		
				close c01;		
				end;
			end if;
		end if;
	end loop;
	 
end if;	
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE hc_envio_ci_clepa ( ds_lista_checklist_p text, nr_seq_paciente_hc_p bigint default 0, nm_usuario_p text  DEFAULT NULL) FROM PUBLIC;
