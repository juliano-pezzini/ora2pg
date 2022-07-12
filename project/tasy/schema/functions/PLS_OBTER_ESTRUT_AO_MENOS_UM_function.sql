-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_estrut_ao_menos_um ( nr_seq_estrutura_p bigint, nr_seq_guia_p bigint, nr_seq_conta_p bigint, cd_procedimento_p bigint, ie_origem_proced_p bigint, cd_proc_conta_p bigint, ie_origem_proc_conta_p bigint) RETURNS varchar AS $body$
DECLARE


ie_retorno_w                    varchar(1)     := 'N';
ie_estrutura_w                  varchar(1)     := 'N';
cd_procedimento_w               bigint := 0;
cd_area_procedimento_w          bigint := 0;
cd_especialidade_w              bigint := 0;
cd_grupo_proc_w                 bigint := 0;
ie_origem_proced_w              bigint;
ie_origem_proced_ww             bigint;
qt_proc_ocorrencia_w            integer := 0;
qt_contador_w                   integer := 0;
qt_item_proc_w                  integer := 0;
qt_proc_w                       integer := 0;
qt_item_proc_ocor_w		bigint := 0;

C01 CURSOR FOR
        SELECT  cd_procedimento,
                ie_origem_proced
        from    pls_guia_plano_proc
        where   nr_seq_guia = nr_seq_guia_p
        group by cd_procedimento,
                 ie_origem_proced
        order by 1;

C02 CURSOR FOR
        SELECT  cd_procedimento,
                ie_origem_proced
        from    pls_conta_proc
        where   nr_seq_conta = nr_seq_conta_p
        group by cd_procedimento,
                 ie_origem_proced
        order by 1;


BEGIN

/* Definição; Ao menos um
     --------------------------------------------------------------------------------------------
    Tem que haver no minimo um dos procedimentos da estrutura na conta.
    Os outros procedimentos além deste recebram ocorrência

    No caso de uma regra Autorização/Conta é gerado ocorrência na guia/conta por não haver ao menos um daqueles procedimentos cadastrados na regra.

   No caso de uma regra Itens é gerado ocorrência nos Itens que não estão cadastrados na regra.

    Retorna :	'S' se necessita gerar ocorrência
	'N' se não necessita

    Obs: O procedimento da regra (cd_procedimento_p) funciona como uma adendo da estrutura ou seja
             Caso exista funciona como se fosse parte da estrutura
*/
if (coalesce(nr_seq_guia_p,0) > 0) then
	open C01;
	loop
	fetch C01 into
		cd_procedimento_w,
		ie_origem_proced_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		begin
		/*Se o procedimento da guia fazer parte da estrutura NÂO recebe ocorrência*/

		ie_estrutura_w := pls_obter_se_estrut_ocorrencia(nr_seq_estrutura_p, cd_procedimento_w, ie_origem_proced_w, '');
		if (ie_estrutura_w = 'S') then
			goto final;
		end if;
		end;
	end loop;
	close C01;
elsif (coalesce(nr_seq_conta_p,0) > 0) then
	open C02;
	loop
	fetch C02 into
		cd_procedimento_w,
		ie_origem_proced_w;
	EXIT WHEN NOT FOUND; /* apply on C02 */
		begin
		/*Se o procedimento da conta fazer parte da estrutura NÂO recebe ocorrência*/

		ie_estrutura_w := pls_obter_se_estrut_ocorrencia(nr_seq_estrutura_p, cd_procedimento_w, ie_origem_proced_w, '');
		if (ie_estrutura_w = 'S') then
			goto final;
		end if;
		end;
	end loop;
	close C02;

end if;

/*Se chegou a este ponto com o ie_estrutura como 'N' então não existe o procedimento da estrutura na conta e deve-se gerar ocorrencia*/

<<final>>
ie_retorno_w := ie_estrutura_w;

/*Se verificado a estrutura e encontrou motivo para gerar a ocorrência
     Então faz-se a verificação se existe o procedimento da regra na conta/guia*/
if (ie_retorno_w = 'N') then
	/*Retorna S se existe
	Retorna N se não existe*/
	ie_retorno_w := pls_obter_proc_exige_ocor(cd_procedimento_p,ie_origem_proced_p,nr_seq_conta_p, null, null);
end if;


/*Diego OPS - OS - 281816 - Se for uma regra do tipo itens e não existir o procedimento na regra então todos os procedimentos recebem ocorrência
     Visto com o Srº Felipe Ambrósio no dia 28/01/2011*/
/*Tratamento realizado para que se mantenha uma lógica no valor da variável*/

select	CASE WHEN ie_retorno_w='N' THEN 'S' WHEN ie_retorno_w='S' THEN 'N' END
into STRICT	ie_retorno_w
;

return  ie_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_estrut_ao_menos_um ( nr_seq_estrutura_p bigint, nr_seq_guia_p bigint, nr_seq_conta_p bigint, cd_procedimento_p bigint, ie_origem_proced_p bigint, cd_proc_conta_p bigint, ie_origem_proc_conta_p bigint) FROM PUBLIC;
