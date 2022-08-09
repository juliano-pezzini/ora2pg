-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_agt_consistir_idade_sexo ( nr_seq_lote_guia_aut_p bigint, nr_seq_lote_proc_aut_p bigint, nr_seq_guia_plano_p bigint, nm_usuario_p text) AS $body$
DECLARE


/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade: Consistir se a 'Idade do Beneficiário incompatível com o Procedimento'.
-------------------------------------------------------------------------------------------------------------------
Locais de chamada direta:
[ X]  Objetos do dicionário [ ] Tasy (Delphi/Java) [  ] Portal [  ]  Relatórios [ ] Outros:
 ------------------------------------------------------------------------------------------------------------------
Pontos de atenção: Performance.
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
cd_pessoa_fisica_w		varchar(10);
ie_tipo_segurado_w		varchar(5);
ie_sexo_w			varchar(1);
cd_procedimento_w		bigint;
nr_seq_guia_plano_proc_w	bigint;
nr_seq_guia_proc_w		bigint;
ie_origem_proced_w		bigint;
nr_seq_prestador_w		bigint;
nr_seq_segurado_w		bigint;
qt_idade_w			integer;
qt_idade_permitida_w		smallint;
qt_sexo_permitido_w		smallint;


BEGIN

select	max(cd_procedimento)
into STRICT	cd_procedimento_w
from	pls_lote_anexo_proc_aut
where	nr_sequencia	= nr_seq_lote_proc_aut_p;

select	max(ie_origem_proced)
into STRICT	ie_origem_proced_w
from	pls_guia_plano_proc
where	cd_procedimento	= cd_procedimento_w
and	nr_seq_guia 	= nr_seq_guia_plano_p;

select	max(nr_seq_segurado)
into STRICT	nr_seq_segurado_w
from	pls_guia_plano
where	nr_sequencia	= nr_seq_guia_plano_p;

begin
	select	b.cd_pessoa_fisica,
		b.ie_sexo,
		a.ie_tipo_segurado
	into STRICT	cd_pessoa_fisica_w,
		ie_sexo_w,
		ie_tipo_segurado_w
	from	pls_segurado 		a,
		pessoa_fisica 		b
	where	a.cd_pessoa_fisica	= b.cd_pessoa_fisica
	and	a.nr_sequencia 		= nr_seq_segurado_w;
exception
when others then
	cd_pessoa_fisica_w	:= '';
	ie_sexo_w		:= '';
end;

qt_idade_w := pls_obter_idade_segurado(nr_seq_segurado_w, clock_timestamp(), 'A');

if (coalesce(nr_seq_guia_plano_p,0) <> 0) then
	select	nr_seq_prestador
	into STRICT	nr_seq_prestador_w
	from	pls_guia_plano
	where	nr_sequencia = nr_seq_guia_plano_p;

		select	count(1)
		into STRICT	qt_sexo_permitido_w
		from	procedimento
		where	cd_procedimento	= cd_procedimento_w
		and	ie_origem_proced	= ie_origem_proced_w
		and	((coalesce(ie_sexo_sus,ie_sexo_w) = ie_sexo_w) or (ie_sexo_sus = 'I'));

		if (qt_sexo_permitido_w = 0) and (ie_tipo_segurado_w not in ('I','H')) then
			CALL pls_inserir_glosa_anexo_guia('1802', nr_seq_lote_guia_aut_p, nr_seq_lote_proc_aut_p, null, nm_usuario_p);
		end if;

		select	count(1)
		into STRICT	qt_idade_permitida_w
		from	procedimento
		where	cd_procedimento		= cd_procedimento_w
		and	ie_origem_proced	= ie_origem_proced_w
		and	qt_idade_w between coalesce(qt_idade_minima_sus,qt_idade_w) and coalesce(qt_idade_maxima_sus,qt_idade_w);

		if (qt_idade_permitida_w = 0) and (ie_tipo_segurado_w not in ('I','H')) then
			CALL pls_inserir_glosa_anexo_guia('1803', nr_seq_lote_guia_aut_p, nr_seq_lote_proc_aut_p, null, nm_usuario_p);
		end if;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_agt_consistir_idade_sexo ( nr_seq_lote_guia_aut_p bigint, nr_seq_lote_proc_aut_p bigint, nr_seq_guia_plano_p bigint, nm_usuario_p text) FROM PUBLIC;
