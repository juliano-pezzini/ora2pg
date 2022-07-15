-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE alvaro_atualizar_referencia ( nr_seq_exame_p bigint, nr_seq_resultado_p bigint, nr_seq_prescr_p bigint, ds_referencia_p text) AS $body$
DECLARE

      
nr_prescricao_w		bigint;
nr_seq_formato_w	bigint;
nr_seq_material_w	bigint;
ie_sexo_w     varchar(10);
cd_pessoa_fisica_w			pessoa_fisica.cd_pessoa_fisica%type;
nr_idade_w    bigint;
nm_usuario_w   varchar(100);
ie_atual_ref_ger_laudo_w varchar(1);
cd_estabelecimento_w	smallint;
ds_referencia_w		varchar(4000);


BEGIN 
 
select nr_prescricao, 
    nm_usuario 
into STRICT nr_prescricao_w, 
   nm_usuario_w 
from exame_lab_resultado 
where nr_seq_resultado = nr_seq_resultado_p;
 
select cd_pessoa_fisica 
into STRICT cd_pessoa_fisica_w 
from atendimento_paciente 
where nr_atendimento = (SELECT NR_ATENDIMENTO 
            from prescr_medica 
            where nr_prescricao = nr_prescricao_w);
 
select	max(nr_seq_material), 
    max(nr_seq_formato) 
into STRICT	nr_seq_material_w, 
			nr_seq_formato_w 
	from	exame_lab_result_item 
	where		nr_seq_resultado = nr_seq_resultado_p 
	and		nr_seq_prescr = nr_seq_prescr_p;
  
  
 select ie_sexo 
 into STRICT ie_sexo_w 
 from pessoa_fisica 
 where cd_pessoa_fisica = cd_pessoa_fisica_w;
  
 nr_idade_w:=Obter_Idade_PF(cd_pessoa_fisica_w, clock_timestamp(),'A');
 
CALL Gera_Resultado_Lab(nr_seq_resultado_p, nr_prescricao_w, nr_seq_prescr_p, nr_seq_exame_p, nr_seq_material_w, nr_idade_w, ie_sexo_w, nm_usuario_w, nr_seq_formato_w);
 
select ds_referencia 
into STRICT ds_referencia_w 
from exame_lab_result_item 
where	nr_seq_exame = nr_seq_exame_p 
	and		nr_seq_resultado = nr_seq_resultado_p 
	and		nr_seq_prescr = nr_seq_prescr_p;
 
select coalesce(max(cd_estabelecimento),0) 
into STRICT cd_estabelecimento_w 
from prescr_medica 
where nr_prescricao = nr_prescricao_w;
 
select coalesce(max(IE_ATUAL_REF_GER_LAUDO),'S') 
into STRICT ie_atual_ref_ger_laudo_w 
from LAB_PARAMETRO 
where cd_estabelecimento = cd_estabelecimento_w;
 
if (ie_atual_ref_ger_laudo_w = 'T') then 
 update	exame_lab_result_item 
 set	ds_referencia = REPLACE(ds_referencia_p,CHR(10),CHR(13)||CHR(10)) 
 where	nr_seq_resultado = nr_seq_resultado_p 
 and	nr_seq_exame = nr_seq_exame_p 
 and	nr_seq_prescr = nr_seq_prescr_p;
end if;
 
 
if (ie_atual_ref_ger_laudo_w = 'N' and coalesce(ds_referencia_w::text, '') = '') then 
 update	exame_lab_result_item 
 set	ds_referencia = REPLACE(ds_referencia_p,CHR(10),CHR(13)||CHR(10)) 
 where	nr_seq_resultado = nr_seq_resultado_p 
 and	nr_seq_exame = nr_seq_exame_p 
 and	nr_seq_prescr = nr_seq_prescr_p;
end if;
 
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE alvaro_atualizar_referencia ( nr_seq_exame_p bigint, nr_seq_resultado_p bigint, nr_seq_prescr_p bigint, ds_referencia_p text) FROM PUBLIC;

