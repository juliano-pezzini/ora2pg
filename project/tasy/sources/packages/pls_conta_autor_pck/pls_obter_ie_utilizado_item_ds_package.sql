-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION pls_conta_autor_pck.pls_obter_ie_utilizado_item_ds ( nr_seq_guia_p pls_guia_plano.nr_sequencia%type, nr_seq_guia_proc_p pls_guia_plano_proc.nr_sequencia%type, nr_seq_guia_mat_p pls_guia_plano_mat.nr_sequencia%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type) RETURNS varchar AS $body$
DECLARE


ie_retorno_w		varchar(1)	:= 'N';
cd_guia_ok_w		pls_guia_plano.cd_guia%type;
qt_autorizada_w		pls_conta_mat.qt_material%type;
qt_utilizada_w		pls_conta_mat.qt_material%type;
qt_saldo_w		pls_conta_mat.qt_material%type;
nr_seq_material_w	pls_conta_mat.nr_seq_material%type;
cd_procedimento_w	pls_conta_proc.cd_procedimento%type;
ie_origem_proced_w	pls_conta_proc.ie_origem_proced%type;
cd_guia_ok_conta_w	pls_guia_plano.cd_guia%type;
nr_seq_segurado_w	pls_guia_plano.nr_seq_segurado%type;
nr_seq_conta_w		pls_conta.nr_sequencia%type;


BEGIN

select 	max(nr_sequencia),
	max(cd_guia_ok),
	max(cd_guia),
	max(nr_seq_segurado)
into STRICT 	nr_seq_conta_w,
	cd_guia_ok_conta_w,
	cd_guia_ok_w,
	nr_seq_segurado_w
from pls_conta
where nr_seq_guia = nr_seq_guia_p;

-- Busca material
if (nr_seq_guia_p IS NOT NULL AND nr_seq_guia_p::text <> '') and (nr_seq_guia_mat_p IS NOT NULL AND nr_seq_guia_mat_p::text <> '') then

			select	max(nr_seq_material),
				max(qt_autorizada)
			into STRICT	nr_seq_material_w,
				qt_autorizada_w
			from	pls_guia_plano_mat
			where	nr_sequencia = nr_seq_guia_mat_p;
			
			select 	coalesce(sum(qt_saldo), 0),
				coalesce(sum(qt_utilizada), 0)
			into STRICT	qt_saldo_w,
				qt_utilizada_w
			from 	table(pls_conta_autor_pck.obter_dados_material_ds(nr_seq_guia_p, nr_seq_material_w, cd_estabelecimento_p, cd_guia_ok_conta_w, nr_seq_segurado_w));
				
			if (coalesce(nr_seq_conta_w::text, '') = '' and coalesce(cd_guia_ok_conta_w::text, '') = '' and coalesce(cd_guia_ok_w::text, '') = '') then
				ie_retorno_w	:= 'N';
			elsif (qt_saldo_w <= 0) then
				ie_retorno_w	:= 'U';			
			elsif (qt_saldo_w = qt_autorizada_w) then
				ie_retorno_w	:= 'N';
			else
				ie_retorno_w	:= 'P';
			end if;
	
end if;
-- Busca procedimento
if (nr_seq_guia_p IS NOT NULL AND nr_seq_guia_p::text <> '') and (nr_seq_guia_proc_p IS NOT NULL AND nr_seq_guia_proc_p::text <> '') then

			select	max(cd_procedimento),
				max(ie_origem_proced),
				max(qt_autorizada)
			into STRICT	cd_procedimento_w,
				ie_origem_proced_w,
				qt_autorizada_w
			from	pls_guia_plano_proc
			where	nr_sequencia = nr_seq_guia_proc_p;
			
			select 	coalesce(sum(qt_saldo),0),
				coalesce(sum(qt_utilizada),0)
			into STRICT	qt_saldo_w,
				qt_utilizada_w
			from 	table(pls_conta_autor_pck.obter_dados_procedimento_ds(	nr_seq_guia_p, ie_origem_proced_w, cd_procedimento_w, cd_guia_ok_conta_w, nr_seq_segurado_w));
			
			if (coalesce(nr_seq_conta_w::text, '') = '' and coalesce(cd_guia_ok_conta_w::text, '') = '' and coalesce(cd_guia_ok_w::text, '') = '') then
				ie_retorno_w	:= 'N';
			elsif (qt_saldo_w <= 0) then
				ie_retorno_w	:= 'U';			
			elsif (qt_saldo_w = qt_autorizada_w) then
				ie_retorno_w	:= 'N';			
			else
				ie_retorno_w	:= 'P';
			end if;
end if;

return	ie_retorno_w;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION pls_conta_autor_pck.pls_obter_ie_utilizado_item_ds ( nr_seq_guia_p pls_guia_plano.nr_sequencia%type, nr_seq_guia_proc_p pls_guia_plano_proc.nr_sequencia%type, nr_seq_guia_mat_p pls_guia_plano_mat.nr_sequencia%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type) FROM PUBLIC;
