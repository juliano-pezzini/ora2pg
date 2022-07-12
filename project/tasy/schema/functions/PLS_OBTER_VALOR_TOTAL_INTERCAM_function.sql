-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_valor_total_intercam ( nr_seq_item_p bigint, ie_tipo_item_p text) RETURNS bigint AS $body$
DECLARE


/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade: Cálcular o valor do item vezes sua quantidade
-------------------------------------------------------------------------------------------------------------------
Locais de chamada direta:
[X]  Objetos do dicionário [ ] Tasy (Delphi/Java) [  ] Portal [  ]  Relatórios [ ] Outros:
 ------------------------------------------------------------------------------------------------------------------
Pontos de atenção: Performance.
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
vl_retorno_w				double precision;
nr_seq_requisicao_w			bigint;
ie_tipo_processo_w			varchar(2);
ie_tipo_intercambio_w			varchar(2);
vl_total_w				double precision;
qt_total_w				bigint;
qt_procedimento_w			bigint;
qt_material_w				bigint;
qt_solicitado_w				bigint;


BEGIN

if (ie_tipo_item_p	= 'P') then
	begin
		select	nr_seq_requisicao,
			qt_procedimento,
			qt_solicitado
		into STRICT	nr_seq_requisicao_w,
			qt_procedimento_w,
			qt_solicitado_w
		from	pls_requisicao_proc
		where	nr_sequencia	= nr_seq_item_p;
	exception
	when others then
		nr_seq_requisicao_w	:= null;
	end;

	begin
		select	ie_tipo_processo,
			ie_tipo_intercambio
		into STRICT	ie_tipo_processo_w,
			ie_tipo_intercambio_w
		from	pls_requisicao
		where	nr_sequencia	= nr_seq_requisicao_w;
	exception
	when others then
		ie_tipo_processo_w	:= null;
		ie_tipo_intercambio_w	:= null;
	end;

	if (ie_tipo_processo_w	= 'I') and (ie_tipo_intercambio_w	= 'I') then
		if (coalesce(qt_procedimento_w,0)	= 0) then
			qt_total_w	:= qt_solicitado_w;
		else
			qt_total_w	:= qt_procedimento_w;
		end if;

		begin
			select (vl_procedimento * qt_total_w)
			into STRICT	vl_total_w
			from	pls_requisicao_proc
			where	nr_sequencia	= nr_seq_item_p;
		exception
		when others then
			vl_total_w	:= null;
		end;
	elsif (ie_tipo_processo_w	= 'I') and (ie_tipo_intercambio_w	= 'E') then
		if (coalesce(qt_procedimento_w,0)	= 0) then
			qt_total_w	:= qt_solicitado_w;
		else
			qt_total_w	:= qt_procedimento_w;
		end if;

		begin
			select (vl_procedimento * qt_total_w)
			into STRICT	vl_total_w
			from	pls_requisicao_proc
			where	nr_sequencia	= nr_seq_item_p;
		exception
		when others then
			vl_total_w	:= null;
		end;
	end if;
elsif (ie_tipo_item_p	= 'M') then
	begin
		select	nr_seq_requisicao,
			qt_material,
			qt_solicitado
		into STRICT	nr_seq_requisicao_w,
			qt_material_w,
			qt_solicitado_w
		from	pls_requisicao_mat
		where	nr_sequencia	= nr_seq_item_p;
	exception
	when others then
		nr_seq_requisicao_w	:= null;
	end;

	begin
		select	ie_tipo_processo,
			ie_tipo_intercambio
		into STRICT	ie_tipo_processo_w,
			ie_tipo_intercambio_w
		from	pls_requisicao
		where	nr_sequencia	= nr_seq_requisicao_w;
	exception
	when others then
		ie_tipo_processo_w	:= null;
		ie_tipo_intercambio_w	:= null;
	end;

	if (ie_tipo_processo_w	= 'I') and (ie_tipo_intercambio_w	= 'I') then
		if (coalesce(qt_material_w,0)	= 0) then
			qt_total_w	:= qt_solicitado_w;
		else
			qt_total_w	:= qt_material_w;
		end if;

		begin
			select (vl_material * qt_total_w)
			into STRICT	vl_total_w
			from	pls_requisicao_mat
			where	nr_sequencia	= nr_seq_item_p;
		exception
		when others then
			vl_total_w	:= null;
		end;
	elsif (ie_tipo_processo_w	= 'I') and (ie_tipo_intercambio_w	= 'E') then
		if (coalesce(qt_material_w,0)	= 0) then
			qt_total_w	:= qt_solicitado_w;
		else
			qt_total_w	:= qt_material_w;
		end if;

		begin
			select (vl_material * qt_total_w)
			into STRICT	vl_total_w
			from	pls_requisicao_mat
			where	nr_sequencia	= nr_seq_item_p;
		exception
		when others then
			vl_total_w	:= null;
		end;
	end if;
end if;

vl_retorno_w	:= vl_total_w;

return	vl_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_valor_total_intercam ( nr_seq_item_p bigint, ie_tipo_item_p text) FROM PUBLIC;
