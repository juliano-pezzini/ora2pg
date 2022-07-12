-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_recursa_item_regra ( nr_seq_item_p pls_conta_proc.nr_sequencia%type, nr_seq_conta_p pls_conta.nr_sequencia%type, nr_seq_prestador_p pls_prestador.nr_sequencia%type, ie_tipo_item_p text) RETURNS varchar AS $body$
DECLARE

				 
/* 
ie_tipo_item_p 
C - Conta 
P - Procedimento 
M - Material 
*/
 
			 
ie_verificar_regra_recurso_w		pls_parametros_rec_glosa.ie_verificar_regra_recurso%type;
qt_item_apresentado_w			integer;
qt_conta_fechadas_w			integer;
cd_prestador_w				pls_prestador.cd_prestador%type;
ie_permite_recurso_pos_w		pls_regra_recurso.ie_permite_recurso_pos%type;

C01 CURSOR FOR 
	SELECT	ie_permite_recurso_pos 
	from	pls_regra_recurso 
	where	((cd_prestador	= cd_prestador_w) or (coalesce(cd_prestador::text, '') = '')) 
	order by ie_permite_recurso_pos;

BEGIN 
 
select	max(coalesce(ie_verificar_regra_recurso,'N')) 
into STRICT	ie_verificar_regra_recurso_w 
from	pls_parametros_rec_glosa;
 
if (ie_verificar_regra_recurso_w <> 'S') then 
	return 'S';
end if;
 
cd_prestador_w	:= substr(pls_obter_dados_prestador(nr_seq_prestador_p,'CD'),1,255);
 
ie_permite_recurso_pos_w	:= 'S';
 
for r_c01 in c01 loop 
	ie_permite_recurso_pos_w	:= r_c01.ie_permite_recurso_pos;
end loop;
 
if (ie_permite_recurso_pos_w = 'S') then 
	return 'S';
end if;
 
select	count(1) 
into STRICT	qt_conta_fechadas_w 
from	pls_rec_glosa_conta	a 
where	a.nr_seq_conta		= nr_seq_conta_p 
and	a.ie_status		= '2';
 
if (ie_tipo_item_p = 'P') then 
	select	count(1) 
	into STRICT	qt_item_apresentado_w 
	from	pls_rec_glosa_proc	b, 
		pls_rec_glosa_conta	a 
	where	b.nr_seq_conta_rec	= a.nr_sequencia 
	and	b.nr_seq_conta_proc	= nr_seq_item_p;
elsif (ie_tipo_item_p = 'M') then 
	select	count(1) 
	into STRICT	qt_item_apresentado_w 
	from	pls_rec_glosa_mat	b, 
		pls_rec_glosa_conta	a 
	where	b.nr_seq_conta_rec	= a.nr_sequencia 
	and	b.nr_seq_conta_mat	= nr_seq_item_p;
end if;
	 
if (qt_conta_fechadas_w = 0) then 
	return 'S';
else 
	if (qt_item_apresentado_w > 0) then 
		return 'S';
	end if;
	 
	return 'N';
end if;	
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_recursa_item_regra ( nr_seq_item_p pls_conta_proc.nr_sequencia%type, nr_seq_conta_p pls_conta.nr_sequencia%type, nr_seq_prestador_p pls_prestador.nr_sequencia%type, ie_tipo_item_p text) FROM PUBLIC;

