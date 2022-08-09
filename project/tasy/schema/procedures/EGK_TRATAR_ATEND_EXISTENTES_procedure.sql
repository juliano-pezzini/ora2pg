-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE egk_tratar_atend_existentes ( nr_episodio_p bigint, cd_convenio_novo_p bigint, nm_usuario_p text, cd_pessoa_fisica_p text ) AS $body$
DECLARE


qt_categoria_w			bigint;
qt_convenio_igual_w		bigint := 0;
ds_erro_w			varchar(300);
atend_categoria_convenio_w	atend_categoria_convenio%rowtype;
nr_seq_interno_w		atend_categoria_convenio.nr_seq_interno%type;
dt_inicio_vigencia_w		pessoa_titular_convenio.dt_inicio_vigencia%type;
dt_fim_vigencia_w		pessoa_titular_convenio.dt_fim_vigencia%type;
dt_validade_carteira_w		pessoa_titular_convenio.dt_validade_carteira%type;
cd_usuario_convenio_w		pessoa_titular_convenio.cd_usuario_convenio%type;
cd_plano_convenio_w		pessoa_titular_convenio.cd_plano_convenio%type;
ie_tipo_conveniado_w		pessoa_titular_convenio.ie_tipo_conveniado%type;
cd_complemento_w		pessoa_titular_convenio.cd_complemento%type;
cd_categoria_w			pessoa_titular_convenio.cd_categoria%type;
nr_prioridade_w			atend_categoria_convenio.nr_prioridade%type;
nr_atendimento_w		atend_categoria_convenio.nr_atendimento%type;
cd_convenio_w			atend_categoria_convenio.cd_convenio%type;

c01 CURSOR FOR
	SELECT	ap.nr_atendimento,
		acc.cd_convenio
	from	atendimento_paciente ap,
		atend_categoria_convenio acc,
		pessoa_juridica pj,
		convenio c
	where	ap.nr_seq_episodio = nr_episodio_p
	and	acc.nr_atendimento = ap.nr_atendimento
	and	c.cd_convenio = acc.cd_convenio
	and	pj.cd_cgc = c.cd_cgc
	and	acc.cd_convenio	<> cd_convenio_novo_p
	and	acc.cd_convenio	<> ger_obter_convenio_pj(acc.nr_atendimento)
	and	c.ie_tipo_convenio = 11
	and not exists (SELECT 1
			from	atend_categoria_convenio b
			where	b.nr_atendimento = ap.nr_atendimento
			and	b.cd_convenio = cd_convenio_novo_p
			and	coalesce(b.dt_final_vigencia::text, '') = '')
	
union

	select		ap.nr_atendimento,
			null
	from		atendimento_paciente ap
	where		ap.nr_seq_episodio = nr_episodio_p
	and not exists (select	1
			from	atend_categoria_convenio b,
				convenio cv
			where	b.nr_atendimento = ap.nr_atendimento
			and	cv.cd_convenio = b.cd_convenio
			and	cv.cd_convenio <> ger_obter_convenio_pj(ap.nr_atendimento)
			and	cv.ie_tipo_convenio = 11);

c02 CURSOR FOR
	SELECT	nr_seq_interno
	from	atend_categoria_convenio
	where	nr_atendimento	=	nr_atendimento_w
	and	cd_convenio	=	cd_convenio_w;
	
procedure obter_conv_igual_existente is
;
BEGIN

select	count(*)
into STRICT	qt_convenio_igual_w
from	atend_categoria_convenio
where	nr_atendimento = nr_atendimento_w
and	cd_convenio = cd_convenio_novo_p
and	(dt_final_vigencia IS NOT NULL AND dt_final_vigencia::text <> '');

end;	


procedure obter_dados_conv_pessoa is
begin

select  nextval('atend_categoria_convenio_seq')
into STRICT    atend_categoria_convenio_w.nr_seq_interno
;

select  ptc.dt_inicio_vigencia,
	ptc.dt_fim_vigencia,
	ptc.dt_validade_carteira,
	ptc.cd_usuario_convenio,
	ptc.cd_plano_convenio,
	ptc.ie_tipo_conveniado,
	ptc.cd_complemento,
	ptc.cd_categoria
into STRICT	dt_inicio_vigencia_w,
	dt_fim_vigencia_w,
	dt_validade_carteira_w,
	cd_usuario_convenio_w,
	cd_plano_convenio_w,
	ie_tipo_conveniado_w,
	cd_complemento_w,
	cd_categoria_w
from	pessoa_titular_convenio ptc
where 	ptc.cd_convenio = cd_convenio_novo_p
and 	ptc.cd_pessoa_fisica = cd_pessoa_fisica_p;

select	CASE WHEN atend_categoria_convenio_w.nr_prioridade=0 THEN  obter_prior_padrao_conv_atend(nr_atendimento_w, cd_convenio_novo_p) WHEN coalesce(atend_categoria_convenio_w.nr_prioridade::text, '') = '' THEN  obter_prior_padrao_conv_atend(nr_atendimento_w, cd_convenio_novo_p)  ELSE atend_categoria_convenio_w.nr_prioridade END
into STRICT	nr_prioridade_w
;

end;	

begin
begin
open C01;
loop
	fetch C01 into
		nr_atendimento_w,
		cd_convenio_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
	open C02;
	loop
		fetch C02 into
			nr_seq_interno_w;
		EXIT WHEN NOT FOUND; /* apply on C02 */

		select  *
		into STRICT    atend_categoria_convenio_w
		from    atend_categoria_convenio
		where   nr_atendimento  = nr_atendimento_w
		and	nr_seq_interno  = nr_seq_interno_w;
	
		update	atend_categoria_convenio
		set	dt_final_vigencia = clock_timestamp(),
			nr_prioridade	= 0
		where   nr_atendimento  = nr_atendimento_w
		and	nr_seq_interno  = nr_seq_interno_w;
		
		obter_conv_igual_existente;
		
		if (qt_convenio_igual_w = 0) then
			obter_dados_conv_pessoa;

			atend_categoria_convenio_w.cd_convenio  	:= cd_convenio_novo_p;
			atend_categoria_convenio_w.dt_atualizacao	:= clock_timestamp();
			atend_categoria_convenio_w.nm_usuario		:= nm_usuario_p;
			atend_categoria_convenio_w.dt_inicio_vigencia	:= dt_inicio_vigencia_w;
			atend_categoria_convenio_w.dt_final_vigencia	:= dt_fim_vigencia_w;
			atend_categoria_convenio_w.dt_validade_carteira	:= dt_validade_carteira_w;
			atend_categoria_convenio_w.cd_usuario_convenio	:= cd_usuario_convenio_w;
			atend_categoria_convenio_w.cd_plano_convenio	:= cd_plano_convenio_w;
			atend_categoria_convenio_w.ie_tipo_conveniado	:= ie_tipo_conveniado_w;
			atend_categoria_convenio_w.cd_complemento	:= cd_complemento_w;
			atend_categoria_convenio_w.cd_categoria		:= cd_categoria_w;
			atend_categoria_convenio_w.nr_prioridade	:= nr_prioridade_w;

			insert into atend_categoria_convenio values (atend_categoria_convenio_w.*);
		else
			update	atend_categoria_convenio
			set	dt_final_vigencia  = NULL,
				nr_prioridade	= atend_categoria_convenio_w.nr_prioridade
			where   nr_atendimento  = nr_atendimento_w
			and	cd_convenio	= cd_convenio_novo_p;
		end if;
		
	end loop;
	close C02;
end loop;
close C01;

if (coalesce(cd_convenio_w::text, '') = '') then
	obter_dados_conv_pessoa;

	atend_categoria_convenio_w.nr_atendimento	:= nr_atendimento_w;
	atend_categoria_convenio_w.cd_convenio  	:= cd_convenio_novo_p;
	atend_categoria_convenio_w.dt_atualizacao	:= clock_timestamp();
	atend_categoria_convenio_w.nm_usuario		:= nm_usuario_p;
	atend_categoria_convenio_w.dt_inicio_vigencia	:= dt_inicio_vigencia_w;
	atend_categoria_convenio_w.dt_final_vigencia	:= dt_fim_vigencia_w;
	atend_categoria_convenio_w.dt_validade_carteira	:= dt_validade_carteira_w;
	atend_categoria_convenio_w.cd_usuario_convenio	:= cd_usuario_convenio_w;
	atend_categoria_convenio_w.cd_plano_convenio	:= cd_plano_convenio_w;
	atend_categoria_convenio_w.ie_tipo_conveniado	:= ie_tipo_conveniado_w;
	atend_categoria_convenio_w.cd_complemento	:= cd_complemento_w;
	atend_categoria_convenio_w.cd_categoria		:= cd_categoria_w;
	atend_categoria_convenio_w.nr_prioridade	:= nr_prioridade_w;

	insert into atend_categoria_convenio values (atend_categoria_convenio_w.*);
end if;

exception
when others then
	ds_erro_w	:=	substr(dbms_utility.format_error_backtrace || chr(13) || chr(10) || sqlerrm,1,4000);
	CALL egk_inserir_log(nm_usuario_p, ds_erro_w);
end;

commit;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE egk_tratar_atend_existentes ( nr_episodio_p bigint, cd_convenio_novo_p bigint, nm_usuario_p text, cd_pessoa_fisica_p text ) FROM PUBLIC;
