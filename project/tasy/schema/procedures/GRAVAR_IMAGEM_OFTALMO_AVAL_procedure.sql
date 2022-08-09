-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gravar_imagem_oftalmo_aval ( nr_sequencia_p bigint, ds_destino_imagem_p text, nm_arquivo_ret_p INOUT text, ds_arquivo_p INOUT text, nm_usuario_p text, cd_estabelecimento_p bigint) AS $body$
DECLARE

					 
nr_sequencia_w	bigint;
qt_imagem_w	bigint;
ds_arquivo_w	varchar(80);
ds_titulo_w	varchar(60);	
ds_extensao_w	varchar(30);
ie_ds_arquivo	varchar(2);
nm_paciente_w	varchar(255);	
nr_atendimento_w	varchar(10);			
						 

BEGIN 
 
ie_ds_arquivo := obter_param_usuario(3010, 48, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p, ie_ds_arquivo);
 
if (ds_destino_imagem_p IS NOT NULL AND ds_destino_imagem_p::text <> '') and (nr_sequencia_p IS NOT NULL AND nr_sequencia_p::text <> '') then 
	select	count(*) 
	into STRICT	qt_imagem_w 
	from  	oft_imagem 
	where 	nr_sequencia_p = nr_sequencia_p;
	 
	if (qt_imagem_w = 1) then 
		select	max(a.ds_arquivo), 
			max(a.ds_titulo) 
		into STRICT	 
			ds_arquivo_w, 
			ds_titulo_w 
		from  	oft_imagem a 
		where 	nr_sequencia_p = nr_sequencia_p;
		 
		if (ds_arquivo_w IS NOT NULL AND ds_arquivo_w::text <> '') and (ds_titulo_w IS NOT NULL AND ds_titulo_w::text <> '') and (position('.' in ds_arquivo_w) > 0) then 
			ds_extensao_w := substr(ds_arquivo_w,position('.' in ds_arquivo_w),30);
			 
			select	nextval('oft_consulta_imagem_seq') 
			into STRICT	nr_sequencia_w 
			;
			 
			if (ie_ds_arquivo = 'NS') then 
				SELECT max(a.nr_atendimento), 
					max(SUBSTR(obter_nome_pf(coalesce(a.cd_pessoa_fisica,obter_pessoa_atendimento(a.nr_atendimento,'C'))),1,255)) 
				into STRICT	nr_atendimento_w, 
					nm_paciente_w 
				FROM  MED_AVALIACAO_PACIENTE a 
				WHERE  a.nr_sequencia  = nr_sequencia_p;
				if (nr_atendimento_w IS NOT NULL AND nr_atendimento_w::text <> '') then 
					 nr_atendimento_w := nr_atendimento_w || '_';
				end if;
				if (nm_paciente_w IS NOT NULL AND nm_paciente_w::text <> '') then 
					nm_paciente_w := nm_paciente_w || '_';
				end if;
			end if;
			 
			insert into oft_consulta_imagem( 
				nr_sequencia, 
				dt_atualizacao, 
				nm_usuario, 
				dt_atualizacao_nrec, 
				nm_usuario_nrec, 
				ds_titulo, 
				ds_arquivo, 
				ds_arquivo_backup, 
				nr_seq_avaliacao) 
			values ( 
				nr_sequencia_w, 
				clock_timestamp(), 
				nm_usuario_p, 
				clock_timestamp(), 
				nm_usuario_p, 
				ds_titulo_w, 
				CASE WHEN ie_ds_arquivo='S' THEN ds_destino_imagem_p || to_char(nr_sequencia_w) || ds_extensao_w  ELSE ds_destino_imagem_p || nr_atendimento_w || nm_paciente_w || to_char(nr_sequencia_w) || ds_extensao_w END , 
				ds_arquivo_w, 
				nr_sequencia_p);
			commit;	
			if (ie_ds_arquivo = 'S') then 
				nm_arquivo_ret_p	:= ds_destino_imagem_p || to_char(nr_sequencia_w) || ds_extensao_w;
				ds_arquivo_p		:= ds_arquivo_w;	
			else 
				nm_arquivo_ret_p	:= ds_destino_imagem_p || nr_atendimento_w || nm_paciente_w || to_char(nr_sequencia_w) || ds_extensao_w;
				ds_arquivo_p		:= ds_arquivo_w;
			end if;
		end if;		
	end if;		
end if;	
	 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gravar_imagem_oftalmo_aval ( nr_sequencia_p bigint, ds_destino_imagem_p text, nm_arquivo_ret_p INOUT text, ds_arquivo_p INOUT text, nm_usuario_p text, cd_estabelecimento_p bigint) FROM PUBLIC;
