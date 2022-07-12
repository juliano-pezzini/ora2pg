-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION qua_obter_se_exibe_doc_relac ( nr_seq_doc_p bigint, nm_usuario_p text) RETURNS varchar AS $body$
DECLARE




ie_visualiza_w		varchar(2);
nr_seq_revisao_w	bigint;
cd_pessoa_w		varchar(10);
cd_cargo_w		bigint;
cd_setor_atendimento_w	bigint;


BEGIN

select	max(cd_pessoa_fisica),
	max(cd_setor_atendimento)
into STRICT	cd_pessoa_w,
	cd_setor_atendimento_w
from	usuario
where	nm_usuario = nm_usuario_p;

select	coalesce(max(nr_sequencia),0)
into STRICT	nr_seq_revisao_w
from	qua_doc_revisao a
where	nr_seq_doc = nr_seq_doc_p;

--Se nao existir revisao verifica as pessoas do documento
if (nr_seq_revisao_w = 0) then
	begin
	--Pessoas elaboracao - documento
	begin
	select	'S'
	into STRICT	ie_visualiza_w
	from	qua_documento
	where	nr_sequencia = nr_seq_doc_p
	and	cd_pessoa_elaboracao = cd_pessoa_w  LIMIT 1;
	exception
	when others then
		ie_visualiza_w := 'N';
	end;
	
	if (coalesce(ie_visualiza_w,'N') = 'N') then
		begin
		select	(obter_cargo_pf(cd_pessoa_w,'C'))::numeric ,
			case when(nm_usuario = nm_usuario_p and coalesce(cd_pessoa_elaboracao::text, '') = '') then 'S' else 'N'end
		into STRICT 	cd_cargo_w,
			ie_visualiza_w
		from	qua_documento
		where	nr_sequencia = nr_seq_doc_p;
		end;
	end if;
	
	--Pasta participantes - elaboracao - documento
	if (coalesce(ie_visualiza_w,'N') = 'N') then
		begin
		begin
		select	'S'
		into STRICT	ie_visualiza_w
		from	qua_doc_participante
		where	nr_seq_doc = nr_seq_doc_p
		and	ie_tipo = 'E'
		and	cd_participante = cd_pessoa_w  LIMIT 1;
		exception
		when others then
			ie_visualiza_w := 'N';
		end;
		end;
	end if;
	
	--Pessoas validacao - documento
	if (coalesce(ie_visualiza_w,'N') = 'N') then
		begin
		begin
		select	'S'
		into STRICT	ie_visualiza_w
		from	qua_documento
		where	nr_sequencia = nr_seq_doc_p
		and	cd_pessoa_validacao = cd_pessoa_w
		and ((dt_elaboracao IS NOT NULL AND dt_elaboracao::text <> '') or (dt_validacao IS NOT NULL AND dt_validacao::text <> ''))  LIMIT 1;
		exception
		when others then
			ie_visualiza_w := 'N';
		end;
		end;
	end if;
	--Pasta Validadores - documento
	if (coalesce(ie_visualiza_w,'N') = 'N') then
		begin
		begin
		select	'S'
		into STRICT	ie_visualiza_w
		from	qua_doc_validacao b,
			qua_documento a
		where	a.nr_sequencia = b.nr_seq_doc
		and	b.nr_seq_doc = nr_seq_doc_p
		and	coalesce(b.cd_pessoa_validacao,cd_pessoa_w) = cd_pessoa_w
		and	coalesce(b.cd_cargo,coalesce(cd_cargo_w,0)) = coalesce(cd_cargo_w,0)
		and ((a.dt_elaboracao IS NOT NULL AND a.dt_elaboracao::text <> '') or (b.dt_validacao IS NOT NULL AND b.dt_validacao::text <> ''))  LIMIT 1;
		exception
		when others then
			ie_visualiza_w := 'N';
		end;
		end;
	end if;
	--Pasta participantes - validacao - documento
	if (coalesce(ie_visualiza_w,'N') = 'N') then
		begin
		begin
		select	'S'
		into STRICT	ie_visualiza_w
		from	qua_doc_participante b,
			qua_documento a
		where	a.nr_sequencia = b.nr_seq_doc
		and	b.nr_seq_doc = nr_seq_doc_p
		and	b.ie_tipo = 'V'
		and	b.cd_participante = cd_pessoa_w
		and	(a.dt_elaboracao IS NOT NULL AND a.dt_elaboracao::text <> '')  LIMIT 1;
		exception
		when others then
			ie_visualiza_w := 'N';
		end;
		end;
	end if;
	
	--Pessoas aprovacao - Documento
	if (coalesce(ie_visualiza_w,'N') = 'N') then
		begin
		begin
		select	'S'
		into STRICT	ie_visualiza_w
		from	qua_documento
		where	nr_sequencia = nr_seq_doc_p
		and	cd_pessoa_aprov = cd_pessoa_w
		and ((dt_validacao IS NOT NULL AND dt_validacao::text <> '') or (dt_aprovacao IS NOT NULL AND dt_aprovacao::text <> ''))  LIMIT 1;
		exception
		when others then
			ie_visualiza_w := 'N';
		end;
		end;
	end if;
	--Pasta Aprovadores  - aprovacao - documento
	if (coalesce(ie_visualiza_w,'N') = 'N') then
		begin
		begin
		select	'S'
		into STRICT	ie_visualiza_w
		from	qua_doc_aprov b,
			qua_documento a
		where	nr_seq_doc = nr_seq_doc_p
		and	coalesce(b.cd_pessoa_aprov,cd_pessoa_w) = cd_pessoa_w
		and	coalesce(b.cd_cargo,coalesce(cd_cargo_w,0)) = coalesce(cd_cargo_w,0)
		and	coalesce(b.cd_setor_atendimento,coalesce(cd_setor_atendimento_w,0)) = coalesce(cd_setor_atendimento_w,0)
		and ((a.dt_validacao IS NOT NULL AND a.dt_validacao::text <> '') or (b.dt_aprovacao IS NOT NULL AND b.dt_aprovacao::text <> ''))  LIMIT 1;
		exception
		when others then
			ie_visualiza_w := 'N';
		end;
		end;
	end if;
	--Pasta participantes - aprovacao - documento
	if (coalesce(ie_visualiza_w,'N') = 'N') then
		begin
		begin
		select	'S'
		into STRICT	ie_visualiza_w
		from	qua_doc_participante b,
			qua_documento a
		where	b.nr_seq_doc = nr_seq_doc_p
		and	b.ie_tipo = 'A'
		and	b.cd_participante = cd_pessoa_w
		and	(a.dt_elaboracao IS NOT NULL AND a.dt_elaboracao::text <> '')  LIMIT 1;
		
		exception
		when others then
			ie_visualiza_w := 'N';
		end;
		end;
	end if;
	end;
else -- Se existir revisao considera somente as pessoas da ultima revisao
	begin
	cd_cargo_w := (obter_cargo_pf(cd_pessoa_w,'C'))::numeric;
	--Pessoas revisao
	begin
	select	'S'
	into STRICT	ie_visualiza_w
	from	qua_doc_revisao
	where	nr_sequencia = nr_seq_revisao_w
	and	cd_pessoa_revisao = cd_pessoa_w  LIMIT 1;
	exception
	when others then
		ie_visualiza_w := 'N';
	end;
	--Pessoas validacao - revisao
	if (coalesce(ie_visualiza_w,'N') = 'N') then
		begin
		begin
		select	'S'
		into STRICT	ie_visualiza_w
		from	qua_doc_revisao
		where	nr_sequencia = nr_seq_revisao_w
		and	cd_pessoa_validacao = cd_pessoa_w  LIMIT 1;
		exception
		when others then
			ie_visualiza_w := 'N';
		end;
		end;
	end if;
	--Pasta Validacao - revisao
	if (coalesce(ie_visualiza_w,'N') = 'N') then
		begin
		begin
		select	'S'
		into STRICT	ie_visualiza_w
		from	qua_doc_revisao_validacao
		where	nr_seq_doc_revisao = nr_seq_revisao_w
		and	coalesce(cd_pessoa_validacao,cd_pessoa_w) = cd_pessoa_w
		and	coalesce(cd_cargo,coalesce(cd_cargo_w,0)) = coalesce(cd_cargo_w,0)  LIMIT 1;
		exception
		when others then
			ie_visualiza_w := 'N';
		end;
		end;
	end if;
	--Aprovador
	if (coalesce(ie_visualiza_w,'N') = 'N') then
		begin
		begin
		select	'S'
		into STRICT	ie_visualiza_w
		from	qua_doc_revisao
		where	nr_sequencia = nr_seq_revisao_w
		and	cd_pessoa_aprovacao = cd_pessoa_w
		and ((dt_validacao IS NOT NULL AND dt_validacao::text <> '') or (dt_aprovacao IS NOT NULL AND dt_aprovacao::text <> ''))  LIMIT 1;
		
		exception
		when others then
			ie_visualiza_w := 'N';
		end;
		end;
	end if;
	--Pasta Aprovadores
	if (coalesce(ie_visualiza_w,'N') = 'N') then
		begin
		begin
		select	'S'
		into STRICT	ie_visualiza_w
		from	qua_doc_revisao_aprovacao b,
			qua_doc_revisao	a
		where	a.nr_sequencia = b.nr_seq_revisao
		and	a.nr_sequencia = nr_seq_revisao_w
		and	coalesce(b.cd_pessoa_aprov,cd_pessoa_w) = cd_pessoa_w
		and	coalesce(b.cd_cargo,coalesce(cd_cargo_w,0)) = coalesce(cd_cargo_w,0)
		and ((a.dt_validacao IS NOT NULL AND a.dt_validacao::text <> '') or (b.dt_aprovacao IS NOT NULL AND b.dt_aprovacao::text <> ''))  LIMIT 1;
		exception
		when others then
			ie_visualiza_w := 'N';
		end;
		end;
	end if;
	end;
end if;

return	ie_visualiza_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION qua_obter_se_exibe_doc_relac ( nr_seq_doc_p bigint, nm_usuario_p text) FROM PUBLIC;

