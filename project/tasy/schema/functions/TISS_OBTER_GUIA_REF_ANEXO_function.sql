-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION tiss_obter_guia_ref_anexo (cd_estabelecimento_p bigint, cd_convenio_p bigint, nr_sequencia_autor_p bigint) RETURNS varchar AS $body$
DECLARE

		
cd_autorizacao_w		varchar(20);
cd_senha_w			varchar(20);
cd_senha_provisoria_w		varchar(20);
ie_guia_ref_anexo_w		varchar(10);
ds_retorno_w			varchar(255);
nr_atendimento_w		bigint;
nr_seq_agenda_w			autorizacao_convenio.nr_seq_agenda%type;
nr_seq_age_integ_w		autorizacao_convenio.nr_seq_age_integ%type;
nr_seq_agenda_consulta_w	autorizacao_convenio.nr_seq_agenda_consulta%type;
nr_seq_gestao_w			bigint;
nr_seq_paciente_w		bigint;
nr_seq_paciente_setor_w		bigint;
nr_seq_rxt_tratamento_w		bigint;
cd_autorizacao_internacao_w	varchar(20);
nr_doc_conv_principal_w		varchar(20);
cd_autorizacao_prest_w		autorizacao_convenio.cd_autorizacao_prest%type;

C01 CURSOR FOR
	SELECT 	a.cd_autorizacao
	from 	autorizacao_convenio a,
		estagio_autorizacao  b
	where 	((a.ie_tipo_autorizacao = '1') or (ie_guia_ref_anexo_w in ('M','P')))
	and  	a.nr_seq_estagio 	= b.nr_sequencia
	and 	b.ie_interno 		not in ('70','90')
	and 	a.nr_atendimento	= nr_atendimento_w
	and	(a.cd_autorizacao IS NOT NULL AND a.cd_autorizacao::text <> '')
	order by a.ie_tipo_autorizacao desc,
		a.nr_sequencia desc;
		
C02 CURSOR FOR
	SELECT 	a.cd_autorizacao
	from 	autorizacao_convenio a,
		estagio_autorizacao  b
	where 	((a.ie_tipo_autorizacao = '1') or (ie_guia_ref_anexo_w in ('M','P')))
	and  	a.nr_seq_estagio 	= b.nr_sequencia
	and 	b.ie_interno 		not in ('70','90')
	and 	a.nr_seq_agenda		= nr_seq_agenda_w
	and	(a.cd_autorizacao IS NOT NULL AND a.cd_autorizacao::text <> '')
	order by a.ie_tipo_autorizacao desc,
		a.nr_sequencia desc;
		
C03 CURSOR FOR
	SELECT 	a.cd_autorizacao
	from 	autorizacao_convenio a,
		estagio_autorizacao  b
	where 	((a.ie_tipo_autorizacao = '1') or (ie_guia_ref_anexo_w in ('M','P')))
	and  	a.nr_seq_estagio 	= b.nr_sequencia
	and 	b.ie_interno 		not in ('70','90')
	and 	a.nr_seq_agenda_consulta = nr_seq_agenda_consulta_w
	and	(a.cd_autorizacao IS NOT NULL AND a.cd_autorizacao::text <> '')
	order by a.ie_tipo_autorizacao desc,
		a.nr_sequencia desc;	

C04 CURSOR FOR
	SELECT 	a.cd_autorizacao
	from 	autorizacao_convenio a,
		estagio_autorizacao  b
	where 	((a.ie_tipo_autorizacao = '1') or (ie_guia_ref_anexo_w in ('M','P')))
	and  	a.nr_seq_estagio 	= b.nr_sequencia
	and 	b.ie_interno 		not in ('70','90')
	and 	a.nr_seq_age_integ	= nr_seq_age_integ_w
	and	(a.cd_autorizacao IS NOT NULL AND a.cd_autorizacao::text <> '')
	order by a.ie_tipo_autorizacao desc,
		 a.nr_sequencia desc;	
		
C05 CURSOR FOR
	SELECT 	a.cd_autorizacao
	from 	autorizacao_convenio a,
		estagio_autorizacao  b
	where 	((a.ie_tipo_autorizacao = '1') or (ie_guia_ref_anexo_w in ('M','P')))
	and  	a.nr_seq_estagio 	= b.nr_sequencia
	and 	b.ie_interno 		not in ('70','90')
	and 	a.nr_seq_gestao		= nr_seq_gestao_w
	and	(a.cd_autorizacao IS NOT NULL AND a.cd_autorizacao::text <> '')
	order by a.ie_tipo_autorizacao desc,
		 a.nr_sequencia desc;	
		
C06 CURSOR FOR	 
	SELECT 	a.cd_autorizacao
	from 	autorizacao_convenio a,
		estagio_autorizacao  b
	where 	((a.ie_tipo_autorizacao = '1') or (ie_guia_ref_anexo_w in ('M','P')))
	and  	a.nr_seq_estagio 	= b.nr_sequencia
	and 	b.ie_interno 		not in ('70','90')
	and 	a.nr_seq_paciente	= nr_seq_paciente_w
	and	(a.cd_autorizacao IS NOT NULL AND a.cd_autorizacao::text <> '')
	order by a.ie_tipo_autorizacao desc,
		 a.nr_sequencia desc;	
		 
		 
C07 CURSOR FOR
	SELECT 	a.cd_autorizacao
	from 	autorizacao_convenio a,
		estagio_autorizacao  b
	where 	((a.ie_tipo_autorizacao = '1') or (ie_guia_ref_anexo_w in ('M','P')))
	and  	a.nr_seq_estagio 	= b.nr_sequencia
	and 	b.ie_interno 		not in ('70','90')
	and 	a.nr_seq_paciente_setor	= nr_seq_paciente_setor_w
	and	(a.cd_autorizacao IS NOT NULL AND a.cd_autorizacao::text <> '')
	order by a.ie_tipo_autorizacao desc,
		 a.nr_sequencia desc;	

C08 CURSOR FOR
	SELECT 	a.cd_autorizacao
	from 	autorizacao_convenio a,
		estagio_autorizacao  b
	where 	((a.ie_tipo_autorizacao = '1') or (ie_guia_ref_anexo_w in ('M','P')))
	and  	a.nr_seq_estagio 	= b.nr_sequencia
	and 	b.ie_interno 		not in ('70','90')
	and 	a.nr_seq_rxt_tratamento	= nr_seq_rxt_tratamento_w
	and	(a.cd_autorizacao IS NOT NULL AND a.cd_autorizacao::text <> '')
	order by a.ie_tipo_autorizacao desc,
		 a.nr_sequencia desc;	
	


BEGIN

select	max(cd_autorizacao),
	max(cd_senha),
	max(cd_senha_provisoria),
	max(nr_atendimento),
	max(nr_seq_agenda),
	max(nr_seq_age_integ),
	max(nr_seq_agenda_consulta),
	max(nr_seq_gestao),
	max(nr_seq_paciente),
	max(nr_seq_paciente_setor),
	max(nr_seq_rxt_tratamento),
	max(cd_autorizacao_prest)
into STRICT	cd_autorizacao_w,
	cd_senha_w,
	cd_senha_provisoria_w,
	nr_atendimento_w,
	nr_seq_agenda_w,
	nr_seq_age_integ_w,
	nr_seq_agenda_consulta_w,
	nr_seq_gestao_w,
	nr_seq_paciente_w,
	nr_seq_paciente_setor_w,
	nr_seq_rxt_tratamento_w,
	cd_autorizacao_prest_w
from	autorizacao_convenio
where	nr_sequencia	= nr_sequencia_autor_p;

select	coalesce(max(ie_guia_ref_anexo),'G')	
into STRICT	ie_guia_ref_anexo_w	
from	tiss_parametros_convenio
where	cd_estabelecimento	= cd_estabelecimento_p
and	cd_convenio		= cd_convenio_p;

if (nr_atendimento_w IS NOT NULL AND nr_atendimento_w::text <> '') then
	open C01;
	loop
	fetch C01 into	
		cd_autorizacao_internacao_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		begin
		cd_autorizacao_internacao_w := cd_autorizacao_internacao_w;
		end;
	end loop;
	close C01;
end if;


if (coalesce(cd_autorizacao_internacao_w::text, '') = '') and (nr_seq_agenda_w IS NOT NULL AND nr_seq_agenda_w::text <> '') then
	open C02;
	loop
	fetch C02 into	
		cd_autorizacao_internacao_w;
	EXIT WHEN NOT FOUND; /* apply on C02 */
		begin
		cd_autorizacao_internacao_w := cd_autorizacao_internacao_w;
		end;
	end loop;
	close C02;
end if;



if (coalesce(cd_autorizacao_internacao_w::text, '') = '') and (nr_seq_agenda_consulta_w IS NOT NULL AND nr_seq_agenda_consulta_w::text <> '') then
	open C03;
	loop
	fetch C03 into	
		cd_autorizacao_internacao_w;
	EXIT WHEN NOT FOUND; /* apply on C03 */
		begin
		cd_autorizacao_internacao_w := cd_autorizacao_internacao_w;
		end;
	end loop;
	close C03;
end if;


if (coalesce(cd_autorizacao_internacao_w::text, '') = '') and (nr_seq_age_integ_w IS NOT NULL AND nr_seq_age_integ_w::text <> '') then
	open C04;
	loop
	fetch C04 into	
		cd_autorizacao_internacao_w;
	EXIT WHEN NOT FOUND; /* apply on C04 */
		begin
		cd_autorizacao_internacao_w := cd_autorizacao_internacao_w;
		end;
	end loop;
	close C04;
end if;


if (coalesce(cd_autorizacao_internacao_w::text, '') = '') and (nr_seq_gestao_w IS NOT NULL AND nr_seq_gestao_w::text <> '') then
	open C05;
	loop
	fetch C05 into	
		cd_autorizacao_internacao_w;
	EXIT WHEN NOT FOUND; /* apply on C05 */
		begin
		cd_autorizacao_internacao_w := cd_autorizacao_internacao_w;
		end;
	end loop;
	close C05;
end if;


if (coalesce(cd_autorizacao_internacao_w::text, '') = '') and (nr_seq_paciente_w IS NOT NULL AND nr_seq_paciente_w::text <> '') then
	open C06;
	loop
	fetch C06 into	
		cd_autorizacao_internacao_w;
	EXIT WHEN NOT FOUND; /* apply on C06 */
		begin
		cd_autorizacao_internacao_w := cd_autorizacao_internacao_w;
		end;
	end loop;
	close C06;
end if;

if (coalesce(cd_autorizacao_internacao_w::text, '') = '') and (nr_seq_paciente_setor_w IS NOT NULL AND nr_seq_paciente_setor_w::text <> '') then
	open C07;
	loop
	fetch C07 into	
		cd_autorizacao_internacao_w;
	EXIT WHEN NOT FOUND; /* apply on C07 */
		begin
		cd_autorizacao_internacao_w := cd_autorizacao_internacao_w;
		end;
	end loop;
	close C07;
end if;

if (coalesce(cd_autorizacao_internacao_w::text, '') = '') and (nr_seq_rxt_tratamento_w IS NOT NULL AND nr_seq_rxt_tratamento_w::text <> '') then
	open C08;
	loop
	fetch C08 into	
		cd_autorizacao_internacao_w;
	EXIT WHEN NOT FOUND; /* apply on C08 */
		begin
		cd_autorizacao_internacao_w := cd_autorizacao_internacao_w;
		end;
	end loop;
	close C08;
end if;


select	max(a.nr_doc_conv_principal)
into STRICT	nr_doc_conv_principal_w
from	atend_categoria_convenio a,
	autorizacao_convenio b
where	a.nr_atendimento	= b.nr_atendimento
and	b.cd_convenio		= a.cd_convenio
and	b.nr_sequencia		= nr_sequencia_autor_p;

if (ie_guia_ref_anexo_w = 'G') then
	ds_retorno_w	:= cd_autorizacao_w;
elsif (ie_guia_ref_anexo_w = 'S') then
	ds_retorno_w	:= cd_senha_w;
elsif (ie_guia_ref_anexo_w = 'P') then	
	ds_retorno_w	:= cd_senha_provisoria_w;
elsif (ie_guia_ref_anexo_w = 'I') then	
	ds_retorno_w	:= cd_autorizacao_internacao_w;
elsif (ie_guia_ref_anexo_w = 'A') then	
	ds_retorno_w	:= nr_doc_conv_principal_w;
elsif (ie_guia_ref_anexo_w = 'M') then
	ds_retorno_w	:= cd_autorizacao_internacao_w;
elsif (ie_guia_ref_anexo_w = 'J') then
	
	if (coalesce(cd_autorizacao_internacao_w,'-1') <> '-1') then
		ds_retorno_w	:= cd_autorizacao_internacao_w;
	elsif (coalesce(cd_autorizacao_prest_w,'-1') <> '-1') then
		ds_retorno_w	:= cd_autorizacao_prest_w;
	end if;
end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION tiss_obter_guia_ref_anexo (cd_estabelecimento_p bigint, cd_convenio_p bigint, nr_sequencia_autor_p bigint) FROM PUBLIC;

