-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_valida_tp_guia_aut_apres ( nr_seq_conta_p bigint, nr_seq_regra_tipo_guia_p bigint, ie_gera_ocorrencia_p INOUT text, ds_observacao_p INOUT text) AS $body$
DECLARE


cd_guia_referencia_w		varchar(15);
cd_guia_imp_w			varchar(15);
cd_guia_solic_imp_w		varchar(15);
ie_tipo_guia_guia_w		varchar(5);
ie_tipo_guia_conta_w		varchar(5);
ie_tipo_guia_autor_w		varchar(5);
ie_gera_ocorr_w			varchar(1)	:= 'N';
ie_tipo_guia_autor_regra_w	varchar(2);
nr_seq_segurado_conta_w		bigint;
qt_apresentada_w		bigint	:= 0;
qt_autorizado_w			bigint	:= 0;
nr_seq_protocolo_w		bigint;
ie_origem_protocolo_w		varchar(2);
ds_observacao_w			varchar(4000);
nr_seq_guia_w			pls_conta.nr_seq_guia%type;

BEGIN

begin /*Informações da rega de tipo de guia aprensetada */
select 	ie_tipo_guia_autor
into STRICT	ie_tipo_guia_autor_regra_w
from 	pls_regra_tipo_guia_apres
where 	nr_sequencia	= nr_seq_regra_tipo_guia_p
and	ie_situacao	= 'A';
exception
when others then
	ie_gera_ocorr_w	:= 'S';
	goto final;
end;

if (coalesce(nr_seq_conta_p,0) > 0) then /*Obtem informacoes da conta do portal */
	begin
		select	ie_tipo_guia,
			nr_seq_guia
		into STRICT	ie_tipo_guia_conta_w,
			nr_seq_guia_w
		from 	pls_conta a
		where 	a.nr_sequencia	= nr_seq_conta_p;
	exception
	when others then
		ie_gera_ocorr_w	:= 'S';
		goto final;
	end;

end if;

begin
select	ie_tipo_guia
into STRICT	ie_tipo_guia_autor_w
from	pls_guia_plano
where	nr_sequencia	= nr_seq_guia_w;
exception
when others then
	ie_tipo_guia_autor_w	:= '0';
end;

select	count(1) /* Comparação do apresentado */
into STRICT	qt_apresentada_w
from	pls_regra_tipo_guia_apres
where   nr_sequencia		= nr_seq_regra_tipo_guia_p
and	ie_tipo_guia_autor	= ie_tipo_guia_autor_w;


/* Observação gerada para apresentar na ocorrência da conta médica */

ds_observacao_w := 'Guia executada: '|| obter_valor_dominio(1746, ie_tipo_guia_autor_w) || '. Guia apresentada: '|| obter_valor_dominio(1746, ie_tipo_guia_conta_w);

if (qt_apresentada_w > 0) then /*Se existe guia autorizada para beneficiario igual  a da regra da autorizada */
	select	count(1) /* Comparação do apresentado */
	into STRICT	qt_autorizado_w
	from	pls_regra_tp_guia_ap_item
	where   nr_seq_regra		= nr_seq_regra_tipo_guia_p
	and	ie_tipo_guia_apres	= ie_tipo_guia_conta_w  LIMIT 1;


	if (qt_autorizado_w > 0) then
		ie_gera_ocorr_w	:= 'S';
	end if;
else
	ie_gera_ocorr_w	:= 'S';
end if;

<<final>>
ie_gera_ocorrencia_p	:= ie_gera_ocorr_w;
ds_observacao_p		:= ds_observacao_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_valida_tp_guia_aut_apres ( nr_seq_conta_p bigint, nr_seq_regra_tipo_guia_p bigint, ie_gera_ocorrencia_p INOUT text, ds_observacao_p INOUT text) FROM PUBLIC;

