-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE sus_consiste_laudo_sismama_his (nr_seq_laudo_p bigint, nm_usuario_p text) AS $body$
DECLARE

 
ds_detalhe_w			varchar(255)	:= '';
nr_sequencia_w			bigint;
cd_estabelecimento_w 		smallint;
nr_atendimento_w   		bigint;
ie_diagnostico_imagem_w		varchar(1);
ie_deteccao_lesao_w		varchar(1);
ie_material_enviado_w		smallint;
ie_procedimento_cirurgico_w	smallint;
ie_caracteristica_lesao_w	varchar(1);
ie_neoplasico_maligno_w		varchar(3);
ie_multifocalidade_tumor_w	varchar(2);


BEGIN 
 
begin 
select	a.nr_sequencia, 
	a.cd_estabelecimento, 
	a.nr_atendimento 
into STRICT	nr_sequencia_w, 
	cd_estabelecimento_w, 
	nr_atendimento_w 
from	pessoa_fisica 		c, 
	atendimento_paciente 	b, 
	sismama_atendimento	a 
where	a.nr_sequencia 	 	= nr_seq_laudo_p 
and	a.nr_atendimento 	= b.nr_atendimento 
and	b.cd_pessoa_fisica	= c.cd_pessoa_fisica;
exception 
	when others then 
	CALL wheb_mensagem_pck.exibir_mensagem_abort(174941);
	/*'Problemas para obter as informações do atendimento ao consistir o laudo.'*/
 
	end;
 
if (sus_obter_incolaudo_ativa(80)) then 
	begin 
	 
	begin 
	select coalesce(ie_diagnostico_imagem,'X'), 
		coalesce(ie_deteccao_lesao,'X') 
	into STRICT	ie_diagnostico_imagem_w, 
		ie_deteccao_lesao_w 
	from  sismama_his_dados_clinico 
	where  nr_seq_sismama = nr_sequencia_w;
	exception 
	when others then 
	ie_diagnostico_imagem_w := 'X';
	ie_deteccao_lesao_w	:= 'X';
	end;
	 
	if	((ie_deteccao_lesao_w = 'I' AND ie_diagnostico_imagem_w = 'X') or 
		(ie_deteccao_lesao_w = 'E' AND ie_diagnostico_imagem_w <> 'X') or 
		(ie_deteccao_lesao_w = 'X' AND ie_diagnostico_imagem_w <> 'X')) then 
		begin 
		ds_detalhe_w	:= wheb_mensagem_pck.get_texto(311158,'nr_atendimento_w='||nr_atendimento_w||';'||'nr_seq_sisco_w='||nr_sequencia_w);
		CALL Sus_Laudo_Gravar_Inco(nr_sequencia_w, 80, ds_detalhe_w, cd_estabelecimento_w, nm_usuario_p);
		end;
	end if;
	 
	end;
end if;
 
if (sus_obter_incolaudo_ativa(81)) then 
	begin 
	 
	begin 
	select coalesce(ie_material_enviado,0) 
	into STRICT	ie_material_enviado_w 
	from  sismama_his_dados_clinico 
	where  nr_seq_sismama = nr_sequencia_w;
	exception 
	when others then 
	ie_material_enviado_w := 0;
	end;
	 
	begin 
	select	coalesce(ie_procedimento_cirurgico,0) 
	into STRICT	ie_procedimento_cirurgico_w 
	from	sismama_his_resultado 
	where  nr_seq_sismama = nr_sequencia_w;	
	exception 
	when others then 
	ie_procedimento_cirurgico_w := 0;	
	end;
	 
	 
	if (ie_material_enviado_w <> ie_procedimento_cirurgico_w) then 
		begin 
		ds_detalhe_w	:= wheb_mensagem_pck.get_texto(311158,'nr_atendimento_w='||nr_atendimento_w||';'||'nr_seq_sisco_w='||nr_sequencia_w);
		CALL Sus_Laudo_Gravar_Inco(nr_sequencia_w, 81, ds_detalhe_w, cd_estabelecimento_w, nm_usuario_p);
		end;
	end if;
	 
	end;
end if;
 
if (sus_obter_incolaudo_ativa(82)) then 
	begin 
	 
	begin 
	select	coalesce(ie_caracteristica_lesao,'X') 
	into STRICT	ie_caracteristica_lesao_w 
	from	sismama_his_dados_clinico 
	where  nr_seq_sismama = nr_sequencia_w;
	 
	exception 
	when others then 
		ie_caracteristica_lesao_w := 'X';	
	end;
	 
	if (ie_caracteristica_lesao_w = 'X') then 
		begin 
		ds_detalhe_w	:= wheb_mensagem_pck.get_texto(311158,'nr_atendimento_w='||nr_atendimento_w||';'||'nr_seq_sisco_w='||nr_sequencia_w);
		CALL Sus_Laudo_Gravar_Inco(nr_sequencia_w, 82, ds_detalhe_w, cd_estabelecimento_w, nm_usuario_p);
		end;
	end if;
	 
	end;
end if;
 
if (sus_obter_incolaudo_ativa(83)) then 
	begin 
	 
	begin 
	select	coalesce(ie_neoplasico_maligno,'0') 
	into STRICT	ie_neoplasico_maligno_w 
	from	sismama_his_exame_micro 
	where  nr_seq_sismama = nr_sequencia_w;
	exception 
	when others then 
		ie_neoplasico_maligno_w := '0';
	end;
	 
	begin 
	select	coalesce(ie_multifocalidade_tumor,'A') 
	into STRICT	ie_multifocalidade_tumor_w 
	from	sismama_his_exame_micro 
	where  nr_seq_sismama = nr_sequencia_w;	
	exception 
	when others then 
		ie_multifocalidade_tumor_w := 'A';	
	end;
	 
	if (ie_neoplasico_maligno_w <> '0') and (ie_multifocalidade_tumor_w = 'A') then 
		begin 
		ds_detalhe_w	:= wheb_mensagem_pck.get_texto(311158,'nr_atendimento_w='||nr_atendimento_w||';'||'nr_seq_sisco_w='||nr_sequencia_w);
		CALL Sus_Laudo_Gravar_Inco(nr_sequencia_w, 83, ds_detalhe_w, cd_estabelecimento_w, nm_usuario_p);		
		end;
	end if;
	 
	end;
end if;
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE sus_consiste_laudo_sismama_his (nr_seq_laudo_p bigint, nm_usuario_p text) FROM PUBLIC;
