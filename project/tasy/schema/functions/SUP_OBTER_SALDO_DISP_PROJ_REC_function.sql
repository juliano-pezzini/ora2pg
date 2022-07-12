-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION sup_obter_saldo_disp_proj_rec ( nr_seq_projeto_p bigint) RETURNS bigint AS $body$
DECLARE


vl_saldo_w		projeto_recurso.vl_inicio_projeto%type;
vl_inicio_projeto_w	projeto_recurso.vl_inicio_projeto%type;
ie_param_25_w		varchar(1) := 'N';
nr_seq_projeto_w	projeto_recurso.nr_sequencia%type;


BEGIN
/*
31/07/2015	100.000,00 valor do recurso do projeto
01/08/2015	10.000,00 numa solicitação de compras
01/08/2015	90.000,00 saldo disponível (nesse momento se tentar emitir uma ordem de compra ou uma solicitação com valor maior que 90.000,00 deverá bloquear).
03/08/2015	a solicitação de 10.000,00 virou uma cotação de 9.500,00.
03/08/2015	9.500,00 numa ordem de compra (daquela solicitação de 10.000,00).
03/08/2015	90.500,00 de saldo disponível.

31/07/2015	100.000,00 valor do recurso do projeto
01/08/2015	10.000,00 numa solicitação de compras
01/08/2015	90.000,00 saldo disponível (nesse momento se tentar emitir uma ordem de compra ou uma solicitação com valor maior que 90.000,00 deverá bloquear).
02/08/2015	90.000,00 nova solic compra
02/08/2015	ZERO disponível
03/08/2015	a solicitação de 10.000,00 virou uma cotação de 11.000,00.
03/08/2015	11.000,00 numa ordem de compra (daquela solicitação de 10.000,00). Não irá permitir.
03/08/2015	porque tem ZERO de saldo disponível.*/
select	coalesce(obter_valor_param_usuario(928, 25, obter_perfil_ativo, wheb_usuario_pck.get_nm_usuario, wheb_usuario_pck.get_cd_estabelecimento),'N')
into STRICT	ie_param_25_w
;

ie_param_25_w := 'N';

if (ie_param_25_w = 'N') then
	select	coalesce(sum(vl_inicio_projeto),0) vl_inicio_projeto
	into STRICT	vl_inicio_projeto_w
	from	projeto_recurso
	where	nr_sequencia = nr_seq_projeto_p;
elsif (ie_param_25_w = 'S') then

	select	coalesce(nr_seq_superior,0)
	into STRICT	nr_seq_projeto_w
	from	projeto_recurso
	where	nr_sequencia = nr_seq_projeto_p;

	if (nr_seq_projeto_w = 0) then
		nr_seq_projeto_w := nr_seq_projeto_p;
	end if;

	select	coalesce(sum(vl_inicio_projeto),0) vl_inicio_projeto
	into STRICT	vl_inicio_projeto_w
	from	projeto_recurso
	where (nr_sequencia = nr_seq_projeto_w or nr_sequencia in (SELECT nr_sequencia from projeto_recurso where nr_seq_superior = nr_seq_projeto_w));
end if;

return	vl_inicio_projeto_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION sup_obter_saldo_disp_proj_rec ( nr_seq_projeto_p bigint) FROM PUBLIC;
