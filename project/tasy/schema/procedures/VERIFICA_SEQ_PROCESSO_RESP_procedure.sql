-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE verifica_seq_processo_resp ( cd_processo_aprov_p bigint, nr_sequencia_p bigint, nr_seq_diferente_p bigint, vl_minimo_p bigint, nr_nivel_aprovacao_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text) AS $body$
DECLARE


ds_erro_w		varchar(255);
qt_seq_menor_vl_maior_w	integer;
qt_existe_seq_w		integer;
ie_aprovacao_nivel_w		parametro_compras.ie_aprovacao_nivel%type;


BEGIN

if (nr_seq_diferente_p > 0) then

	select	count(*)
	into STRICT	qt_existe_seq_w
	from 	processo_aprovacao a,
		processo_aprov_resp b
	where	a.cd_processo_aprov = b.cd_processo_aprov
	and	a.cd_estabelecimento = cd_estabelecimento_p
	and	b.nr_sequencia = nr_seq_diferente_p;
	
	if (qt_existe_seq_w > 0) then
		CALL wheb_mensagem_pck.exibir_mensagem_abort(323480);
	--Esta sequencia ja existe em algum processo. Favor verificar
	end if;	
end if;	

select ie_aprovacao_nivel
into STRICT ie_aprovacao_nivel_w
from processo_aprovacao
where cd_processo_aprov = cd_processo_aprov_p;

if (ie_aprovacao_nivel_w = 'A') then
	/* Verifica ordenacao de valores dentro de um mesmo nivel, ou ordenacao dos niveis */

	select	count(*)
	into STRICT	qt_seq_menor_vl_maior_w
	from	processo_aprov_resp
	where	cd_processo_aprov = cd_processo_aprov_p
	and	(
		(coalesce(nr_nivel_aprovacao,0) = nr_nivel_aprovacao_p
			and (((nr_sequencia_p < nr_sequencia) and (vl_minimo_p > coalesce(vl_minimo,0))) or
			((nr_sequencia_p > nr_sequencia) and (vl_minimo_p < coalesce(vl_minimo,0))))
		) or
		((nr_sequencia_p < nr_sequencia) and (nr_nivel_aprovacao_p > coalesce(nr_nivel_aprovacao,0))) or
		((nr_sequencia_p > nr_sequencia) and (nr_nivel_aprovacao_p < coalesce(nr_nivel_aprovacao,0))));
else
	/* Verifica ordenacao de valores, ou ordenacao dos niveis */

	select	count(*)
	into STRICT	qt_seq_menor_vl_maior_w
	from	processo_aprov_resp
	where	cd_processo_aprov = cd_processo_aprov_p
	and	(((nr_sequencia_p < nr_sequencia) and (vl_minimo_p > coalesce(vl_minimo,0))) or
		((nr_sequencia_p > nr_sequencia) and (vl_minimo_p < coalesce(vl_minimo,0))) or
		((nr_sequencia_p < nr_sequencia) and (nr_nivel_aprovacao_p > coalesce(nr_nivel_aprovacao,0))) or
		((nr_sequencia_p > nr_sequencia) and (nr_nivel_aprovacao_p < coalesce(nr_nivel_aprovacao,0))));
end if;

if (qt_seq_menor_vl_maior_w > 0) then
	CALL wheb_mensagem_pck.exibir_mensagem_abort(323449);
end if;
--Os valores e sequencia devem ser registradas de forma ordenadas


--se a sequencia for menor que as outras e o valor for maior que os outros entao faz a consistencia

--se o valor for maior que as outras e a sequencia for menor que as outras entao faz a consistencia
commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE verifica_seq_processo_resp ( cd_processo_aprov_p bigint, nr_sequencia_p bigint, nr_seq_diferente_p bigint, vl_minimo_p bigint, nr_nivel_aprovacao_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text) FROM PUBLIC;

