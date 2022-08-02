-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_consiste_produto ( nr_seq_produto_p bigint, ds_consistencia_p INOUT text) AS $body$
DECLARE


ie_segmentacao_w		varchar(3);
ie_tipo_contratacao_w		varchar(2);
qt_erros_w			bigint;
ds_erro_w			varchar(4000)	:= '';


BEGIN

/* Obter dados do produto */

select	ie_segmentacao,
	ie_tipo_contratacao
into STRICT	ie_segmentacao_w,
	ie_tipo_contratacao_w
from	pls_plano
where	nr_sequencia	= nr_seq_produto_p;

if (ie_tipo_contratacao_w = 'I') then
	/* [1] - Formação do preço incorreta */

	select	count(*)
	into STRICT	qt_erros_w
	from	pls_plano
	where	ie_preco <> '1'
	and	ie_regulamentacao <> 'R'
	and	nr_sequencia	= nr_seq_produto_p;
	if (qt_erros_w > 0) then
		ds_erro_w	:= ds_erro_w || '1 ';
	end if;

	/* [2] - Vínculo do beneficiário não deve ser informado */

	select	count(*)
	into STRICT	qt_erros_w
	from	pls_plano
	where	nr_sequencia	= nr_seq_produto_p
	and (ie_vinculo_ativo	= 'S'
	or	ie_vinculo_inativo	= 'S'
	or	ie_sem_vinculo		= 'S');
	if (qt_erros_w > 0) then
		ds_erro_w	:= ds_erro_w || '2 ';
	end if;

	/* [3] - Participação financeira não deve ser informada */

	select	count(*)
	into STRICT	qt_erros_w
	from	pls_plano
	where	nr_sequencia	= nr_seq_produto_p
	and	ie_participacao	in ('C','S');
	if (qt_erros_w > 0) then
		ds_erro_w	:= ds_erro_w || '3 ';
	end if;
end if;

if (ie_segmentacao_w	= '1') or (ie_segmentacao_w	= '8') then
	/* [4] - Padrão de acomodação não deve ser informado */

	select	count(*)
	into STRICT	qt_erros_w
	from	pls_plano
	where	nr_sequencia	= nr_seq_produto_p
	and	ie_acomodacao	in ('I','C');
	if (qt_erros_w > 0) then
		ds_erro_w	:= ds_erro_w || '4 ';
	end if;
end if;

if (ie_segmentacao_w	= '5') then
	/* [5] - Padrão de acomodação deve ser coletivo */

	select	count(*)
	into STRICT	qt_erros_w
	from	pls_plano
	where	nr_sequencia	= nr_seq_produto_p
	and	ie_acomodacao	<> 'C';
	if (qt_erros_w > 0) then
		ds_erro_w	:= ds_erro_w || '5 ';
	end if;
end if;

if (ie_segmentacao_w	<> '4') then
	/* [6] - Formação do preço inválida para este tipo de segmentação */

	select	count(*)
	into STRICT	qt_erros_w
	from	pls_plano
	where	nr_sequencia	= nr_seq_produto_p
	and	ie_preco	= '4';
	if (qt_erros_w > 0) then
		ds_erro_w	:= ds_erro_w || '6 ';
	end if;
end if;

ds_consistencia_p	:= substr(replace(ds_erro_w, ' ', ','), 0, length(ds_erro_w) -1);

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_consiste_produto ( nr_seq_produto_p bigint, ds_consistencia_p INOUT text) FROM PUBLIC;

