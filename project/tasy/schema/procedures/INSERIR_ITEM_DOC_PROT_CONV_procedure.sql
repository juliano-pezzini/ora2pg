-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE inserir_item_doc_prot_conv ( nr_seq_prot_doc_p bigint, nr_seq_prot_conv_p bigint, ie_tipo_prot_doc_p text, nm_usuario_p text) AS $body$
DECLARE

 
nr_atendimento_w	bigint;
nr_protocolo_w		bigint;
nr_interno_conta_w	bigint;
qt_reg_protocolo	bigint;
nr_seq_item_w		bigint;
cd_convenio_w		bigint;
Qt_Maxima_Contas_Prot_w	bigint;
qt_registro_w		bigint;
nr_seq_tipo_item_w	bigint;
ie_tipo_documento_w	varchar(1);
			
C01 CURSOR FOR 
SELECT	nr_atendimento, 
	nr_interno_conta 
from	conta_paciente 
where	nr_seq_protocolo = nr_seq_prot_conv_p 
order by nr_atendimento;			
			 

BEGIN 
Qt_Maxima_Contas_Prot_w := obter_param_usuario(290, 102, obter_perfil_Ativo, nm_usuario_p, wheb_usuario_pck.get_cd_estabelecimento, Qt_Maxima_Contas_Prot_w);
ie_tipo_documento_w := obter_param_usuario(290, 106, obter_perfil_Ativo, nm_usuario_p, wheb_usuario_pck.get_cd_estabelecimento, ie_tipo_documento_w);
 
if (nr_seq_prot_conv_p > 0) and (coalesce(ie_tipo_prot_doc_p, 'X') in ('2','5')) then 
	open C01;
	loop 
	fetch C01 into	 
		nr_atendimento_w, 
		nr_interno_conta_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		begin 
		if (ie_tipo_documento_w = 'S') then 
			select	nr_seq_tipo_doc_item 
			into STRICT	nr_seq_tipo_item_w 
			from	protocolo_documento 
			where	nr_sequencia = nr_seq_prot_doc_p;
		end if;
		 
		select	coalesce(max(nr_seq_item),0)+1 
		into STRICT	nr_seq_item_w 
		from	protocolo_doc_item 
		where	nr_sequencia	= nr_seq_prot_doc_p;
 
		begin 
		select 	cd_convenio 
		into STRICT	cd_convenio_w 
		from	atend_categoria_convenio 
		where 	nr_seq_interno	= obter_atecaco_atendimento(nr_atendimento_w) 
		and	nr_atendimento	= nr_atendimento_w;
		exception 
		when others then 
			cd_convenio_w := null;
		end;
		 
		if (ie_tipo_prot_doc_p = '5') and (Qt_Maxima_Contas_Prot_w > 0) then 
			select	count(*) 
			into STRICT	qt_registro_w 
			from	protocolo_doc_item 
			where	nr_sequencia	= nr_seq_prot_doc_p 
			and	nr_seq_item	<> nr_seq_item_w;
			 
			if	((qt_registro_w+1) > Qt_Maxima_Contas_Prot_w) then 
				CALL wheb_mensagem_pck.exibir_mensagem_abort(248875);
			end if;
		end if;
		 
		insert into protocolo_doc_item( 
				nr_sequencia, 
				nr_seq_item, 
				nr_documento, 
				nr_seq_interno, 
				nm_usuario, 
				dt_atualizacao, 
				cd_convenio, 
				nr_seq_tipo_item) 
		values (	nr_seq_prot_doc_p, 
				nr_seq_item_w, 
				nr_atendimento_w, 
				CASE WHEN ie_tipo_prot_doc_p='2' THEN ''  ELSE nr_interno_conta_w END , 
				nm_usuario_p, 
				clock_timestamp(), 
				CASE WHEN ie_tipo_prot_doc_p='2' THEN cd_convenio_w  ELSE '' END , 
				nr_seq_tipo_item_w);
		end;
	end loop;
	close C01;
end if;
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE inserir_item_doc_prot_conv ( nr_seq_prot_doc_p bigint, nr_seq_prot_conv_p bigint, ie_tipo_prot_doc_p text, nm_usuario_p text) FROM PUBLIC;

