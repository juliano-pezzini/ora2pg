-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE enviar_email_paciente_orc (ds_email_destino_p text, cd_pessoa_fisica_p text, nm_usuario_p text) AS $body$
DECLARE

 
qt_orcamento_w	integer :=0;
ds_assunto_w	varchar(100);
ds_mensagem_w	varchar(4000):= '';
dt_orcamento_w	timestamp;
dt_validade_w	timestamp;
vl_orcamento_w	double precision;
nr_sequencia_w	bigint;
ds_convenio_w	varchar(255);
ds_categoria_w	varchar(60);
ds_plano_w	varchar(60);
ds_status_orcamento_w	varchar(60);
ds_email_origem_w	varchar(20);
cd_estabelecimento_w	smallint;

C01 CURSOR FOR 
	SELECT	cd_estabelecimento, 
		dt_orcamento, 
		dt_validade, 
		obter_valor_orc_pac(nr_sequencia_orcamento), 
		nr_sequencia_orcamento, 
		substr(obter_nome_convenio(cd_convenio),1,60), 
		substr(obter_categoria_convenio(cd_convenio, cd_categoria),1,60), 
		substr(obter_desc_plano(cd_convenio, cd_plano),1,60), 
		substr(obter_valor_dominio(31,ie_status_orcamento),1,60) 
	from	orcamento_paciente 
	where	cd_pessoa_fisica = cd_pessoa_fisica_p  /* Mostrar apenas os últimos 5 orçamentos */
 
	order by dt_orcamento desc LIMIT 5;


BEGIN 
 
begin 
select 	count(*) 
into STRICT	qt_orcamento_w 
from 	orcamento_paciente 
where	cd_pessoa_fisica = cd_pessoa_fisica_p;
exception 
	when others then 
	qt_orcamento_w:= 0;
end;
 
if (qt_orcamento_w > 0) then 
	ds_assunto_w	:= substr(obter_texto_tasy(294977,wheb_usuario_pck.get_nr_seq_idioma),1,100); --'Aviso - Paciente com Orçamento'; 
	ds_mensagem_w	:= substr(obter_texto_dic_objeto(294980, wheb_usuario_pck.get_nr_seq_idioma, 'NM_PACIENTE='||substr(Obter_nome_pf(cd_pessoa_fisica_p),1,60)),1,255); --'Orçamento(s) do Paciente ' || substr(Obter_nome_pf(cd_pessoa_fisica_p),1,60); 
	OPEN C01;
	LOOP 
	FETCH C01 into 
		cd_estabelecimento_w, 
		dt_orcamento_w, 
		dt_validade_w, 
		vl_orcamento_w, 
		nr_sequencia_w, 
		ds_convenio_w, 
		ds_categoria_w, 
		ds_plano_w, 
		ds_status_orcamento_w;
	EXIT WHEN NOT FOUND; /* apply on c01 */
		begin 
		ds_mensagem_w	:= ds_mensagem_w || chr(10) || chr(10) || chr(10) || 
				obter_texto_dic_objeto(294981, wheb_usuario_pck.get_nr_seq_idioma, 'DT_ORCAMENTO_W='||dt_orcamento_w|| 
				                                  ';DT_VALIDADE_W='||dt_validade_w|| 
												  ';NR_SEQUENCIA_W='||nr_sequencia_w|| 
												  ';VL_ORCAMENTO_W='||vl_orcamento_w|| 
												  ';DS_CONVENIO_W='||ds_convenio_w|| 
												  ';DS_CATEGORIA_W='||ds_categoria_w|| 
												  ';DS_PLANO_W='||ds_plano_w|| 
												  ';DS_STATUS_ORCAMENTO_W='||ds_status_orcamento_w);
												 								 
		/*' Data do Orçamento  : ' || dt_orcamento_w || chr(10) || 
		' Data de Validade  : ' || dt_validade_w || chr(10) || 
		' Nro. do Orçamento  : ' || nr_sequencia_w || chr(10) || 
		' Valor do Orçamento : ' || vl_orcamento_w || chr(10) || 
		' Convênio	     : ' || ds_convenio_w || chr(10) || 
		' Categoria  	 : ' || ds_categoria_w || chr(10) || 
		' Plano		 : ' || ds_plano_w   || chr(10) || 
		' Status do Orçamento : ' || ds_status_orcamento_w; */
 
		 
		end;
	END LOOP;
	CLOSE C01;
	ds_email_origem_w := obter_param_usuario(0, 38, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_w, ds_email_origem_w);
	CALL Enviar_Email(ds_assunto_w, ds_mensagem_w, ds_email_origem_w , ds_email_destino_p, nm_usuario_p, 'M');
end if;
 
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE enviar_email_paciente_orc (ds_email_destino_p text, cd_pessoa_fisica_p text, nm_usuario_p text) FROM PUBLIC;
