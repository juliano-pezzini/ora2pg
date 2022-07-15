-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE ageint_consiste_exame_lab (nr_seq_ageint_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text, ds_erro_p INOUT text) AS $body$
DECLARE


qt_item_bloq_w		bigint;
nr_glosa_part_w		bigint;
ie_bloq_glosa_part_w	varchar(1);
ds_erro_w		varchar(255);


BEGIN

ie_bloq_glosa_part_w := obter_param_usuario(869, 187, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p, ie_bloq_glosa_part_w);

nr_glosa_part_w	:= 99;

if (ie_bloq_glosa_part_w = 'N') then
	nr_glosa_part_w := 8;
end if;

select	count(*)
into STRICT	qt_item_bloq_w
from	ageint_exame_lab a
where	a.nr_seq_ageint = nr_seq_ageint_p
and	((coalesce(a.ie_regra,0) in (1,2,5,nr_glosa_part_w)) or (coalesce(a.ie_glosa,'X') = 'T'))
and	not exists(	SELECT	1
			from	ageint_exame_lab x
			where	a.nr_sequencia = x.nr_seq_origem
			and	((coalesce(x.ie_regra,0) not in (1,2,5,nr_glosa_part_w)) or (coalesce(x.ie_glosa,'X') <> 'T')));

if (qt_item_bloq_w > 0) then
	ds_erro_w	:= WHEB_MENSAGEM_PCK.get_texto(279704,null);
end if;

ds_erro_p	:= ds_erro_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ageint_consiste_exame_lab (nr_seq_ageint_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text, ds_erro_p INOUT text) FROM PUBLIC;

