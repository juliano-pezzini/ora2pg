-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE qua_enviar_nota_part_js ( ds_email_origem_p text, nr_sequencia_p bigint, nm_usuario_p text) AS $body$
DECLARE


vl_nota_w		real;
ds_email_destino_w	varchar(255);	
nr_seq_treinamento_w    bigint;	
ds_treinamento_w	varchar(255);	
ds_assunto_w		varchar(255);	
ds_mensagem_w		varchar(2000);		
					

BEGIN

if (coalesce(nr_sequencia_p,0) > 0) then

	select  substr(max(obter_dados_pf_pj(cd_pessoa_fisica,null, 'M')),1,200),
		max(vl_nota),
		max(nr_seq_treinamento)
	into STRICT	ds_email_destino_w,
		vl_nota_w,
		nr_seq_treinamento_w
	from    qua_doc_trein_pessoa 
	where   (vl_nota IS NOT NULL AND vl_nota::text <> '') 
	and     coalesce(dt_envio_nota::text, '') = ''
	and     nr_sequencia = nr_sequencia_p;

	if (coalesce(nr_seq_treinamento_w,0) > 0) then
		select	ds_treinamento
		into STRICT	ds_treinamento_w
		from 	qua_doc_treinamento 
		where 	nr_sequencia = nr_seq_treinamento_w;
		
		ds_assunto_w:= substr(wheb_mensagem_pck.get_texto(322993, 'DS_TREINAMENTO='||ds_treinamento_w),1,255);
		ds_mensagem_w := substr(wheb_mensagem_pck.get_texto(322994, 'DS_TREINAMENTO='||ds_treinamento_w ||';VL_NOTA=' ||vl_nota_w),1,2000);
		
		CALL enviar_email(ds_assunto_w, ds_mensagem_w, ds_email_origem_p, ds_email_destino_w, nm_usuario_p, 'M', null);
			
		update	qua_doc_trein_pessoa
		set   	dt_envio_nota = clock_timestamp()
		where  nr_sequencia = nr_sequencia_p;
		commit;
	end if;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE qua_enviar_nota_part_js ( ds_email_origem_p text, nr_sequencia_p bigint, nm_usuario_p text) FROM PUBLIC;

