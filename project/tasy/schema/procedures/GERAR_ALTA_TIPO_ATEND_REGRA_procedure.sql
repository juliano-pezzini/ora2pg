-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_alta_tipo_atend_regra ( nr_atendimento_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint) AS $body$
DECLARE

 
ie_tipo_atendimento_w	bigint;					
ie_tipo_atend_alta_w	bigint;
ie_tipo_atend_regra_w	bigint;
nr_atendimento_w	bigint;
cd_motivo_alta_w	bigint;
nr_sequencia_w		bigint;
cd_setor_atendimento_w	bigint;
ds_erro_w		varchar(255);
cd_pessoa_fisica_w	varchar(100);

C01 CURSOR FOR 
	SELECT 	a.nr_atendimento 
	from 	atendimento_paciente a, 
		atend_paciente_unidade b 
	where 	a.cd_pessoa_fisica = cd_pessoa_fisica_w 
	and 	a.nr_atendimento = b.nr_atendimento 
	and	coalesce(a.dt_alta::text, '') = '' 
	and 	a.ie_tipo_atendimento = ie_tipo_atend_alta_w 
	and 	((b.cd_setor_atendimento = cd_setor_atendimento_w) or (cd_setor_atendimento_w = 0));


BEGIN 
 
 
select	coalesce(max(ie_tipo_atendimento),0), 
	coalesce(max(nr_sequencia),0) 
into STRICT	ie_tipo_atend_regra_w, 
	nr_sequencia_w 
from	REGRA_ALTA; /*buscar o tipo de atendimento e a sequencia da regra */
 
select	coalesce(max(cd_pessoa_fisica),0), 
	coalesce(max(ie_tipo_atendimento),0) 
into STRICT	cd_pessoa_fisica_w, 
	ie_tipo_atendimento_w 
from 	atendimento_paciente 
where	nr_atendimento = nr_atendimento_p;
 
 
if (ie_tipo_atend_regra_w > 0) and (ie_tipo_atend_regra_w = ie_tipo_atendimento_w) then 
		 
		select 	coalesce(max(cd_motivo_alta),0), 
			coalesce(max(ie_tipo_atendimento),0), 
			coalesce(max(cd_setor_atendimento),0) 
		into STRICT 	cd_motivo_alta_w, 
			ie_tipo_atend_alta_w, 
			cd_setor_atendimento_w 
		from	REGRA_ALTA_ACAO 
		where	nr_seq_regra_alta = nr_sequencia_w; /* buscar o motivo de alta, o tipo de atendimento, e o setor da regra - comparar com atendimento anterior*/
		 
		 
		open C01;
		loop 
		fetch C01 into	 
			nr_atendimento_w;
		EXIT WHEN NOT FOUND; /* apply on C01 */
			begin 
			 
			if (cd_motivo_alta_w > 0) and (nr_atendimento_w > 0) then 
				ds_erro_w := gerar_estornar_alta(	nr_atendimento_w, 'A', null, cd_motivo_alta_w, clock_timestamp(), nm_usuario_p, ds_erro_w, null, null, wheb_mensagem_pck.get_texto(795839));
				if (ds_erro_w IS NOT NULL AND ds_erro_w::text <> '') then 
					CALL Wheb_mensagem_pck.exibir_mensagem_abort( 262328 , 'DS_MENSAGEM='||ds_erro_w);
				end if;			
			end if;
			 
			end;
		end loop;
		close C01;
 
end if;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_alta_tipo_atend_regra ( nr_atendimento_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint) FROM PUBLIC;

