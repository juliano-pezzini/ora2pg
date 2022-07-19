-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_tiss_consistir_opm ( nr_sequencia_p bigint, ie_tipo_glosa_p text, ie_evento_p text, nr_seq_prestador_p bigint, nr_seq_ocorrencia_p bigint, ds_parametro_um_p text, nm_usuario_p text, cd_estabelecimento_p bigint) AS $body$
DECLARE


/* IE_TIPO_GLOSA_P
	C - Conta
	CP - Conta procedimento
	CM - Conta material
	A - Autorização
	AP - Autorização procedimento
	AM - Autorização material */
cd_guia_w			varchar(20);
ie_conta_intercambio_w		varchar(2);
ie_autorizado_w			varchar(2);
ie_liberar_item_autor_w		varchar(2);
ie_existe_regra_w		varchar(2);
cd_guia_referencia_w		pls_conta.cd_guia_referencia%type;
ie_tipo_conta_w			varchar(2);
ie_evento_w			varchar(2);
ie_tipo_despesa_w		varchar(1)	:= '0';
ie_mat_liberado_w		varchar(1)	:= 'S';
qt_lanc_glosa_w			integer;
qt_utilizada_glosa_w		double precision;
qt_utilizada_w			double precision;
qt_autorizada_w			double precision;
qt_material_imp_w		double precision;
nr_seq_conta_w			bigint;
nr_seq_material_w		bigint;
nr_seq_prestador_exec_w		bigint;
nr_seq_prestador_retorno_w	bigint;
nr_seq_regra_retorno_w		bigint;
nr_seq_guia_w			bigint;
nr_seq_segurado_w		bigint;
qt_saldo_w			pls_conta_mat.qt_material%type;
nr_seq_protocolo_w		pls_protocolo_conta.nr_sequencia%type;
ie_tipo_protocolo_w		pls_protocolo_conta.ie_tipo_protocolo%type;
nr_seq_regra_autor_w		pls_regra_autorizacao.nr_sequencia%type;


BEGIN
ie_evento_w	:= 'CC';

begin
	select	qt_material_imp,
		nr_seq_conta,
		nr_seq_material
	into STRICT	qt_material_imp_w,
		nr_seq_conta_w,
		nr_seq_material_w
	from	pls_conta_mat
	where	nr_sequencia	= nr_sequencia_p;
exception
when others then
	ie_tipo_despesa_w	:= '0';
end;

select	coalesce(coalesce(cd_guia,cd_guia_referencia),'0'),
	cd_guia_referencia,
	nr_seq_prestador_exec,
	CASE WHEN coalesce(ie_tipo_conta,'O')='O' THEN 'N'  ELSE 'I' END ,
	coalesce(ie_tipo_conta,'O'),
	nr_seq_segurado,
	nr_seq_protocolo
into STRICT	cd_guia_w,
	cd_guia_referencia_w,
	nr_seq_prestador_exec_w,
	ie_conta_intercambio_w,
	ie_tipo_conta_w,
	nr_seq_segurado_w,
	nr_seq_protocolo_w
from	pls_conta
where	nr_sequencia	= nr_seq_conta_w;

if (nr_seq_protocolo_w IS NOT NULL AND nr_seq_protocolo_w::text <> '') then
	select	max(ie_tipo_protocolo)
	into STRICT	ie_tipo_protocolo_w
	from	pls_protocolo_conta
	where	nr_sequencia	= nr_seq_protocolo_w;

	if (ie_tipo_protocolo_w = 'R') then
		ie_evento_w := 'CR';
	end if;
end if;

if (cd_guia_w = '0') then
	begin
		select	coalesce(cd_guia_solic_imp,coalesce(cd_guia_imp,'0'))
		into STRICT	cd_guia_w
		from	pls_conta
		where	nr_sequencia	= nr_seq_conta_w;
	exception
	when others then
		cd_guia_w	:= '0';
	end;
end if;

if (ie_conta_intercambio_w	<> 'I') then
	SELECT * FROM pls_obter_tipo_prest_consist(nr_seq_conta_w, nm_usuario_p, nr_seq_prestador_retorno_w, nr_seq_regra_retorno_w) INTO STRICT nr_seq_prestador_retorno_w, nr_seq_regra_retorno_w;
end if;

if (nr_seq_prestador_retorno_w IS NOT NULL AND nr_seq_prestador_retorno_w::text <> '') then
	nr_seq_prestador_exec_w	:= nr_seq_prestador_retorno_w;
end if;

if (ie_tipo_conta_w = 'I') then
	ie_evento_w	:= 'I5';
end if;

/* Obter dados da guia */

select	max(nr_sequencia)
into STRICT	nr_seq_guia_w
from	pls_guia_plano
where	cd_guia		= cd_guia_w
and	nr_seq_segurado	= nr_seq_segurado_w;

if (coalesce(nr_seq_guia_w::text, '') = '')	then
	select  max(nr_sequencia)
	into STRICT	nr_seq_guia_w
	from	pls_guia_plano
	where	cd_guia 	= cd_guia_referencia_w
	and	nr_seq_segurado = nr_seq_segurado_w;

end if;
if (ie_tipo_glosa_p = 'CM') then
	ie_mat_liberado_w	:= pls_obter_qtd_liberada_opm(nr_sequencia_p);
end if;

/* 2204  Quantidade de OPM deve ser maior que zero*/

if (coalesce(qt_material_imp_w,0) < 1) then
	CALL pls_gravar_glosa_tiss('2204', null, ie_evento_p, nr_sequencia_p, ie_tipo_glosa_p, nr_seq_prestador_p, nr_seq_ocorrencia_p, '', nm_usuario_p, cd_estabelecimento_p, nr_seq_conta_w);
end if;

/*  2210  Cobrança de OPM em quantidade incompatível com o procedimento realizado*/

if (ie_mat_liberado_w = 'N') then
	if (ie_tipo_glosa_p =  'CM')	then
		CALL pls_gravar_conta_glosa('2210', null, null, nr_sequencia_p, 'N', '', nm_usuario_p, 'A','SCE', nr_seq_prestador_exec_w, cd_estabelecimento_p, '', null);
	end if;
	CALL pls_gravar_glosa_tiss('2210', null, ie_evento_p, nr_sequencia_p, ie_tipo_glosa_p, nr_seq_prestador_p, nr_seq_ocorrencia_p, '', nm_usuario_p, cd_estabelecimento_p, nr_seq_conta_w);
end if;

SELECT * FROM pls_consiste_mat_autor(nr_seq_conta_w, nr_sequencia_p, nm_usuario_p, cd_estabelecimento_p, nr_seq_prestador_exec_w, ie_liberar_item_autor_w, ie_existe_regra_w, nr_seq_regra_autor_w) INTO STRICT ie_liberar_item_autor_w, ie_existe_regra_w, nr_seq_regra_autor_w;
/* 2206*/

select 	coalesce(max(qt_saldo),0),
	coalesce(max(qt_utilizada),0),
	coalesce(max(qt_autorizada),0)
into STRICT	qt_saldo_w,
	qt_utilizada_w,
	qt_autorizada_w
from 	table(pls_conta_autor_pck.obter_dados(	nr_seq_guia_w, 'M', cd_estabelecimento_p,
						null, null, nr_seq_material_w));

if (coalesce(nr_seq_guia_w,0) <> 0) then

	update	pls_conta_mat
	set	qt_autorizado	= qt_autorizada_w
	where	nr_sequencia	= nr_sequencia_p;

	if	( (qt_saldo_w < 0) and (qt_utilizada_w > 0) and ( ie_liberar_item_autor_w = 'S'))then
			qt_utilizada_glosa_w	:= qt_utilizada_w - qt_autorizada_w;
			qt_lanc_glosa_w		:= pls_obter_qt_glosa_item(null, null, nr_seq_material_w,
									   nr_seq_guia_w, '2206');

			if (qt_lanc_glosa_w < qt_utilizada_glosa_w) then
				CALL pls_gravar_conta_glosa('2206', null, null, nr_sequencia_p, 'N', 'Regra de autorização: ' || nr_seq_regra_autor_w, nm_usuario_p, 'A',ie_evento_w, nr_seq_prestador_exec_w, cd_estabelecimento_p, '', null);
			end if;
	end if;
else
	if (ie_liberar_item_autor_w = 'S') and (qt_autorizada_w = 0) then
		CALL pls_gravar_conta_glosa('2206', null, null, nr_sequencia_p, 'N', 'Regra de autorização: ' || nr_seq_regra_autor_w, nm_usuario_p, 'A', ie_evento_p, nr_seq_prestador_exec_w, cd_estabelecimento_p, '', null);
	end if;
end if;

--commit;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_tiss_consistir_opm ( nr_sequencia_p bigint, ie_tipo_glosa_p text, ie_evento_p text, nr_seq_prestador_p bigint, nr_seq_ocorrencia_p bigint, ds_parametro_um_p text, nm_usuario_p text, cd_estabelecimento_p bigint) FROM PUBLIC;

