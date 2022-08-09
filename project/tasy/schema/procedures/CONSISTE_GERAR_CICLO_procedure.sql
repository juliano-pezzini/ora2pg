-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE consiste_gerar_ciclo ( cd_pessoa_fisica_p text, dt_referencia_p timestamp, nr_seq_paciente_p bigint, nm_usuario_p text, ds_erro_p INOUT text, nr_seq_item_p INOUT bigint) AS $body$
DECLARE

					 
qt_reg_w			bigint;
nr_seq_texto_w			bigint;
ds_textos_necessarios_w		varchar(2000);
qt_dias_w			bigint;
cd_protocolo_w			bigint;
nr_seq_medicacao_w		bigint;
cd_estabelecimento_w		bigint;

C01 CURSOR FOR 
	SELECT	nr_seq_texto, 
		qt_dias_consentimento 
	from	REGRA_CONCENTIMENTO_CICLO 
	where	coalesce(ie_tipo_regra,'C')	= 'C' 
	and	coalesce(cd_protocolo,coalesce(cd_protocolo_w,0)) = coalesce(cd_protocolo_w,0) 
	and	coalesce(nr_seq_medicacao,coalesce(nr_seq_medicacao_w,0)) = coalesce(nr_seq_medicacao_w,0) 
	and	coalesce(cd_estabelecimento,coalesce(cd_estabelecimento_w,0)) = coalesce(cd_estabelecimento_w,0);

BEGIN
 
cd_estabelecimento_w	:= wheb_usuario_pck.get_cd_estabelecimento;
 
select	count(*) 
into STRICT	qt_reg_w 
from	REGRA_CONCENTIMENTO_CICLO 
where	coalesce(ie_tipo_regra,'C')	= 'C';
 
nr_seq_item_p	:= 0;
 
if (qt_reg_w	> 0) then 
 
	select	max(cd_protocolo), 
		max(nr_seq_medicacao) 
	into STRICT	cd_protocolo_w, 
		nr_seq_medicacao_w 
	from	paciente_setor 
	where	nr_seq_paciente = nr_seq_paciente_p;
	 
	open C01;
	loop 
	fetch C01 into	 
		nr_seq_texto_w, 
		qt_dias_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		begin 
		 
		select	count(*) 
		into STRICT	qt_reg_w 
		from	pep_pac_ci 
		where	cd_pessoa_fisica	= cd_pessoa_fisica_p 
		and	nr_seq_texto		= nr_seq_texto_w 
		and	(dt_liberacao IS NOT NULL AND dt_liberacao::text <> '') 
		and	coalesce(dt_inativacao::text, '') = '' 
		and	coalesce(cd_protocolo,coalesce(cd_protocolo_w,0)) = coalesce(cd_protocolo_w,0) 
		and	coalesce(nr_seq_medicacao,coalesce(nr_seq_medicacao_w,0)) = coalesce(nr_seq_medicacao_w,0)		 
		and	((dt_atualizacao_nrec	between(clock_timestamp()-qt_dias_w) and clock_timestamp()) or (coalesce(qt_dias_w::text, '') = ''));					
		 
		if (qt_reg_w	= 0) then 
			ds_textos_necessarios_w	:= ds_textos_necessarios_w||chr(13)||chr(10)||substr(obter_descricao_padrao('TEXTO_PADRAO','DS_TITULO',nr_seq_texto_w),1,120);
		end if;
		end;
	end loop;
	close C01;
 
	if (ds_textos_necessarios_w IS NOT NULL AND ds_textos_necessarios_w::text <> '') then 
		ds_erro_p	:= substr(wheb_mensagem_pck.get_texto(278519, 'DT_REFERENCIA_P=' || to_char(dt_referencia_p,'dd/mm/yyyy hh24:mi:ss') || 
										';DS_TEXTOS_NECESSARIOS_P=' || ds_textos_necessarios_w),1,255);
		nr_seq_item_p	:= 398;
	end if;
	 
else 
	ds_erro_p	:= substr(wheb_mensagem_pck.get_texto(278526, 'DT_REFERENCIA_P=' || to_char(dt_referencia_p,'dd/mm/yyyy hh24:mi:ss')),1,255);
end if;
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE consiste_gerar_ciclo ( cd_pessoa_fisica_p text, dt_referencia_p timestamp, nr_seq_paciente_p bigint, nm_usuario_p text, ds_erro_p INOUT text, nr_seq_item_p INOUT bigint) FROM PUBLIC;
